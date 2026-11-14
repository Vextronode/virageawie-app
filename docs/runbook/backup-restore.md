# Runbook: cadangan dan pemulihan basis data

Cadangan produksi dibuat oleh layanan `backup` di `infra/compose.prod.yaml`: setiap hari (jadwal `BACKUP_SCHEDULE`, bawaan pukul 02.00 WIB) dan sebelum setiap deploy produksi. Isinya `pg_dump` format custom, dienkripsi dengan `age`, lalu diunggah ke Cloudflare R2 dan disimpan selama `BACKUP_RETENTION_DAYS` hari.

Cadangan hanya dapat dibuka dengan **kunci privat age**. Kunci ini tidak pernah disimpan di server atau di repositori; simpan di pengelola kata sandi tim dan minimal satu salinan luring.

## Uji pemulihan berkala

Cadangan dianggap valid hanya jika pernah berhasil dipulihkan. Lakukan uji ini **setiap bulan** dan setelah perubahan pada skrip cadangan atau versi PostgreSQL.

Perintah `backup.sh restore-test` mengunduh cadangan terbaru dari R2 (atau berkas lokal yang disebutkan), mendekripsinya, memulihkannya ke basis data sementara `<nama_db>_restore_test`, memeriksa bahwa tabel `migrations` berisi data, lalu menghapus basis data sementara tersebut, juga jika uji gagal.

Jalankan uji di komputer pengelola, bukan di server, supaya kunci privat tidak pernah berada di server. Langkah berikut memakai PostgreSQL lokal dari `infra/compose.local.yaml` (Linux atau WSL):

1. Jalankan PostgreSQL lokal dan bangun image cadangan dari folder akar repositori:

   ```bash
   docker compose -f infra/compose.local.yaml up -d
   docker build -t virageawie-backup:1 infra/backup
   ```

2. Siapkan berkas env di luar repositori, misalnya `~/virageawie-restore.env`, berisi kredensial R2 yang hanya boleh membaca:

   ```env
   R2_ACCOUNT_ID=...
   R2_ACCESS_KEY_ID=...
   R2_SECRET_ACCESS_KEY=...
   R2_BUCKET=virageawie-backups
   R2_PREFIX=postgres
   ```

3. Jalankan uji:

   ```bash
   docker run --rm --network host \
     --env-file ~/virageawie-restore.env \
     -e PGHOST=127.0.0.1 -e PGPORT=5433 \
     -e PGDATABASE=virageawie -e PGUSER=virageawie -e PGPASSWORD=<kata sandi lokal> \
     -e BACKUP_AGE_IDENTITY_FILE=/run/age-key.txt \
     -v ~/kunci/virageawie-backup.txt:/run/age-key.txt:ro \
     virageawie-backup:1 restore-test
   ```

   Untuk menguji cadangan tertentu, tambahkan nama objeknya setelah `restore-test`, misalnya `restore-test virageawie-20261101T190000Z.dump.age`.

4. Hasil yang diharapkan diakhiri dengan `restore-test: OK`. Jika gagal, laporkan segera; jangan menunggu jadwal uji berikutnya.

5. Catat hasilnya pada tabel di bawah.

### Catatan uji

| Tanggal | Cadangan yang diuji | Hasil | Penguji | Catatan |
| --- | --- | --- | --- | --- |
| | | | | |

## Pemulihan produksi

Gunakan hanya jika data produksi rusak atau hilang. Prosedur ini menimpa basis data produksi.

1. Umumkan gangguan, lalu hentikan aplikasi dan worker agar tidak ada penulisan baru:

   ```bash
   cd <DEPLOY_PATH>/infra
   docker compose --env-file .env -f compose.prod.yaml stop app worker backup
   ```

2. Di komputer pengelola, unduh cadangan yang dipilih dari R2 dan dekripsi:

   ```bash
   age --decrypt --identity ~/kunci/virageawie-backup.txt \
     --output virageawie.dump virageawie-<waktu>.dump.age
   ```

3. Salin `virageawie.dump` ke server melalui jalur yang aman, lalu pulihkan:

   ```bash
   docker compose --env-file .env -f compose.prod.yaml exec -T postgres \
     pg_restore --clean --if-exists --no-owner --no-privileges --exit-on-error \
     -U <PROD_DB_USERNAME> -d <PROD_DB_DATABASE> < virageawie.dump
   ```

4. Hapus berkas dump yang tidak terenkripsi dari server dan komputer pengelola.

5. Jalankan kembali layanan, lalu periksa `https://<PROD_APP_HOST>/up` dan beberapa transaksi terakhir:

   ```bash
   docker compose --env-file .env -f compose.prod.yaml up -d app worker backup
   ```

6. Catat kejadian, cadangan yang dipakai, dan rentang data yang hilang (antara waktu cadangan dan waktu kerusakan).
