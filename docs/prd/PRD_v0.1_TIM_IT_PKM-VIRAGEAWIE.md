# Product Requirements Document (PRD)

**Aplikasi Pencatatan Kas dan Manajemen Persediaan Versi 1**
**Mitra: VirageAwie Indonesia**

| Atribut | Keterangan |
| --- | --- |
| Disusun oleh | TIM IT PKM - VIRAGEAWIE |
| Ditujukan kepada | Tim IT (dokumen teknis internal); bagian 7 dan 10 dikonfirmasi oleh Tim Bisnis |
| Versi dan tanggal | 0.1, 26 Oktober 2026 |
| Status | Draf teknis |
| Dokumen terkait | Deployment Diagram v0.1; Sequence Diagram v0.1 (menyusul) |

---

## Riwayat Versi

| Versi | Tanggal | Perubahan |
| --- | --- | --- |
| 0.1 | 26 Oktober 2026 | Draf pertama, disusun dari keputusan teknis final tanggal 26 Oktober 2026 |

---

## Daftar Isi

1. Pendahuluan
2. Latar Belakang dan Masalah
3. Tujuan dan Metrik Keberhasilan
4. Pengguna dan Hak Akses
5. Ruang Lingkup
6. Kebutuhan Fungsional
7. Aturan Bisnis
8. Kebutuhan Non-Fungsional
9. Batasan dan Keputusan Teknis
10. Asumsi, Ketergantungan, Risiko, dan Pertanyaan Terbuka
11. Rencana Rilis dan Penerimaan
- Lampiran A. Keterlacakan Kebutuhan
- Lampiran B. Ilustrasi Perhitungan

---

## 1. Pendahuluan

### 1.1 Tujuan Dokumen

Dokumen ini menetapkan apa yang dibangun pada versi 1 aplikasi, untuk siapa, dengan aturan apa, dan kapan setiap kebutuhan dianggap selesai. Dokumen ini menjadi acuan bagi perancangan sequence diagram, pengembangan, pengujian, dan User Acceptance Test (UAT).

### 1.2 Ruang Lingkup Dokumen

Dokumen ini mencakup kebutuhan fungsional, aturan bisnis, kebutuhan non-fungsional, batasan teknis, serta rencana rilis dan penerimaan versi 1. Rincian infrastruktur dijelaskan dalam Deployment Diagram v0.1. Rincian alur antarkomponen dijelaskan dalam Sequence Diagram v0.1.

### 1.3 Istilah dan Singkatan

| Istilah | Pengertian |
| --- | --- |
| HPP | Harga Pokok Penjualan, yaitu biaya barang yang terjual |
| Moving average | Metode penilaian persediaan perpetual; biaya rata-rata per unit dihitung ulang setiap ada barang masuk |
| Kantong kas | Tempat penyimpanan dana yang dicatat terpisah, misalnya kas tunai, rekening bank, dompet digital, atau saldo marketplace |
| Periode | Satu bulan kalender pencatatan |
| Kunci periode | Status periode yang tidak lagi menerima transaksi baru, pembatalan, maupun perubahan |
| PWA | Progressive Web App; aplikasi web yang dapat dipasang di layar utama perangkat |
| FR / NFR | Functional Requirement / Non-Functional Requirement |
| KP | Kriteria Penerimaan |
| AB | Aturan Bisnis |
| SD | Sequence Diagram |
| MoSCoW | Prioritas Must, Should, Could, Won't |
| Idempotency key | Kode unik per pengiriman form, digunakan server untuk menolak pencatatan ganda |

### 1.4 Konvensi Status

Setiap kebutuhan dan aturan bisnis diberi salah satu status berikut.

| Status | Arti |
| --- | --- |
| Terkonfirmasi | Berasal dari arahan tertulis Tim Bisnis |
| Asumsi IT | Default Tim IT; berlaku sampai dikoreksi Tim Bisnis |
| Belum diketahui | Menunggu jawaban Tim Bisnis; tidak dikembangkan melewati tingkat dasar sebelum terjawab |

### 1.5 Referensi

1. Gambaran Sistem dan Estimasi Biaya Operasional Versi 1, v0.2, 25 Oktober 2026.
2. Gambaran Sistem dan Kebutuhan Pengembangan Versi 1 (dokumen detail).
3. Daftar Keputusan sebelum PRD, Sequence Diagram, dan Deployment Diagram, keputusan final 26 Oktober 2026.
4. Deployment Diagram v0.1, 26 Oktober 2026.

---

## 2. Latar Belakang dan Masalah

### 2.1 Kondisi Saat Ini

VirageAwie Indonesia adalah usaha produk bambu yang telah menjangkau pasar domestik dan internasional. Pencatatan keuangan dan persediaan masih dilakukan secara manual, penggunaan spreadsheet belum optimal, dan sebagian besar informasi keuangan tersimpan dalam ingatan pemilik usaha.

### 2.2 Pernyataan Masalah

1. Pemilik tidak dapat mengetahui saldo kas dan nilai persediaan secara cepat tanpa merekap manual.
2. Pencatatan kas dan stok dilakukan terpisah, sehingga rawan pencatatan ganda dan selisih antarcatatan.
3. HPP tidak dihitung secara konsisten, sehingga keuntungan per penjualan tidak dapat diketahui dengan andal.
4. Tidak ada jejak perubahan data, sehingga kesalahan pencatatan sulit ditelusuri.

### 2.3 Ringkasan Solusi

Aplikasi web berbentuk PWA yang dapat diakses dari komputer maupun smartphone. Satu kali input transaksi memperbarui kas dan persediaan secara bersamaan dalam satu transaksi database. Persediaan dinilai dengan metode perpetual moving average. Setiap perubahan data tercatat dalam audit trail, dan akses dibatasi menurut role.

---

## 3. Tujuan dan Metrik Keberhasilan

### 3.1 Tujuan

1. Menyediakan saldo kas dan nilai persediaan yang terhitung otomatis dari setiap transaksi.
2. Menghitung HPP secara konsisten dengan metode moving average.
3. Menyediakan jejak perubahan data yang dapat ditelusuri.

### 3.2 Metrik Keberhasilan

| ID | Metrik | Cara pengukuran | Target | Status |
| --- | --- | --- | --- | --- |
| M-01 | Ketepatan perhitungan | Hasil saldo kas, nilai persediaan, dan HPP dibandingkan dengan contoh transaksi berangka dari Tim Bisnis | Sesuai pada 100% kasus uji | Asumsi IT |
| M-02 | Akses informasi oleh pemilik | Pemilik memperoleh saldo kas per kantong dan nilai persediaan dari aplikasi tanpa rekap manual | Tercapai saat UAT | Asumsi IT |
| M-03 | Kedisiplinan pencatatan | Selisih tanggal transaksi dengan tanggal input selama pilot 4 minggu | Paling lambat H+1 untuk minimal 90% transaksi | Asumsi IT |

---

## 4. Pengguna dan Hak Akses

### 4.1 Role

| Role | Deskripsi | Status |
| --- | --- | --- |
| Pemilik | Pemilik usaha. Melihat seluruh data dan laporan, mengelola pengguna, dan dapat menginput transaksi | Asumsi IT |
| Pencatat | Karyawan yang menginput transaksi harian. Tidak melihat saldo kas maupun nilai persediaan | Asumsi IT |
| Akuntan | Pihak yang memverifikasi, mengoreksi, mengelola kategori, menyesuaikan stok, dan mengunci periode | Asumsi IT |

### 4.2 Aturan Penugasan Role

1. Satu pengguna dapat memegang lebih dari satu role. Contoh: pemilik usaha dapat sekaligus memegang role Pemilik dan Akuntan.
2. Setiap pengguna wajib memiliki alamat email yang aktif, karena undangan dan reset password dikirim melalui email.
3. Minimal satu pengguna aktif harus memegang role Pemilik pada setiap saat.

### 4.3 Matriks Hak Akses

Keterangan: Y = diizinkan, T = tidak diizinkan, S = hanya data milik sendiri.

| Aksi | Pemilik | Pencatat | Akuntan |
| --- | --- | --- | --- |
| Menginput kas masuk, kas keluar, transfer, pembelian, penjualan, pelunasan | Y | Y | Y |
| Melihat daftar transaksi | Y | S | Y |
| Melihat jumlah stok tersedia | Y | Y | Y |
| Melihat saldo kas, nilai persediaan, dan HPP | Y | T | Y |
| Melihat laporan dan mengekspor ke Excel | Y | T | Y |
| Membatalkan transaksi bertanggal hari ini | Y | S | Y |
| Membatalkan transaksi bertanggal lampau | Y | T | Y |
| Menginput transaksi bertanggal lampau | Y | T | Y |
| Menyesuaikan stok dan mencatat stock opname | T | T | Y |
| Mengelola master barang, pemasok, dan pelanggan | Y | T | Y |
| Mengelola kategori kas | T | T | Y |
| Mengelola kantong kas | Y | T | Y |
| Mengunci dan membuka kunci periode | T | T | Y |
| Mengimpor data awal | T | T | Y |
| Mengelola pengguna dan role | Y | T | T |
| Melihat audit trail | Y | T | Y |

---

## 5. Ruang Lingkup

### 5.1 Modul Versi 1

1. Akses dan pengguna
2. Data master: barang, kategori kas, kantong kas, pemasok, pelanggan
3. Data awal dan go-live
4. Kas: kas masuk, kas keluar, transfer antar kantong
5. Pembelian dan penjualan, termasuk transaksi kredit dasar dan pelunasan
6. Persediaan: penyesuaian stok, stock opname, retur sederhana
7. Koreksi transaksi dan kunci periode
8. Audit trail
9. Laporan dan ekspor

### 5.2 Ringkasan Prioritas

| Prioritas | Jumlah FR | Daftar |
| --- | --- | --- |
| Must | 18 | FR-01 sampai FR-18 |
| Should | 3 | FR-19, FR-20, FR-21 |
| Could | 2 | FR-22, FR-23 |

Kebutuhan berprioritas Must menjadi syarat rilis. Kebutuhan Should dan Could dapat ditunda ke rilis berikutnya tanpa mengubah dokumen ini, dengan pemberitahuan kepada Tim Bisnis.

### 5.3 Di Luar Ruang Lingkup Versi 1

| No | Hal | Keterangan |
| --- | --- | --- |
| 1 | Laporan akuntansi formal (jurnal umum, laba rugi, neraca) | Data jurnal disiapkan di latar belakang (AB-11), tetapi laporannya tidak ditampilkan |
| 2 | Integrasi bank, marketplace, atau aplikasi lain | Transaksi dicatat manual |
| 3 | Perhitungan pajak otomatis | Pajak dicatat manual sebagai transaksi kas |
| 4 | Mata uang asing | Seluruh nilai dalam Rupiah; penjualan valas dikonversi manual |
| 5 | Mode offline penuh dan background sync | Diganti dengan pengiriman ulang otomatis dan draf form (FR-22) |
| 6 | Aplikasi native Android atau iOS | Tidak termasuk versi 1 |
| 7 | Produksi dengan resep bahan (bill of materials) | Hanya pencatatan dasar barang masuk dari produksi (FR-23) |
| 8 | Multi-usaha dan penggajian | Tidak termasuk |
| 9 | Notifikasi selain undangan pengguna dan reset password | Harus ditambahkan sebagai FR baru bila diperlukan |

### 5.4 Catatan Perubahan Arsitektur

Dokumen detail sebelumnya menyebut bahwa server dirancang terpisah sebagai API agar aplikasi dapat dikembangkan menjadi aplikasi native. Ketentuan tersebut diganti. Versi 1 dibangun sebagai satu aplikasi Laravel dengan antarmuka React melalui Inertia. Kesiapan menuju aplikasi native dijaga dengan menempatkan seluruh logika bisnis pada lapisan Service/Action yang terpisah dari controller, sehingga API dapat ditambahkan kemudian tanpa menulis ulang logika bisnis.

---

## 6. Kebutuhan Fungsional

Setiap kebutuhan memuat deskripsi, prioritas, status, role yang terlibat, dan kriteria penerimaan. Kriteria penerimaan menjadi dasar kasus uji dan UAT.

### 6.1 Akses dan Pengguna

#### FR-01 Login, Logout, dan Sesi

| Atribut | Keterangan |
| --- | --- |
| Deskripsi | Pengguna masuk dengan email dan password, keluar, dan sesi berakhir otomatis setelah tidak aktif |
| Prioritas | Must |
| Status | Asumsi IT |
| Role | Semua |
| Sequence diagram | SD-01 |

Kriteria penerimaan:

1. KP-01.1: Pengguna dengan email dan password yang benar diarahkan ke halaman awal sesuai role.
2. KP-01.2: Lima kali gagal login berturut-turut dalam 15 menit menahan percobaan berikutnya dari akun tersebut selama 15 menit.
3. KP-01.3: Sesi berakhir setelah 120 menit tanpa aktivitas, dan pengguna diarahkan ke halaman login.
4. KP-01.4: Pengguna yang dinonaktifkan tidak dapat login, dan sesi aktifnya berakhir pada permintaan berikutnya.

#### FR-02 Pengelolaan Pengguna dan Role

| Atribut | Keterangan |
| --- | --- |
| Deskripsi | Pemilik mengundang pengguna melalui email, menetapkan role, mengubah role, dan menonaktifkan pengguna |
| Prioritas | Must |
| Status | Asumsi IT |
| Role | Pemilik |

Kriteria penerimaan:

1. KP-02.1: Undangan terkirim ke email pengguna dan berisi tautan pembuatan password yang berlaku 48 jam.
2. KP-02.2: Satu pengguna dapat diberi lebih dari satu role.
3. KP-02.3: Sistem menolak penonaktifan atau pencabutan role Pemilik bila tindakan tersebut menyisakan nol Pemilik aktif.
4. KP-02.4: Pengguna tidak dihapus permanen; pengguna yang dinonaktifkan tetap tercatat pada transaksi dan audit trail.

#### FR-03 Reset Password melalui Email

| Atribut | Keterangan |
| --- | --- |
| Deskripsi | Pengguna yang lupa password meminta tautan reset melalui email |
| Prioritas | Must |
| Status | Asumsi IT |
| Role | Semua |
| Sequence diagram | SD-07 |

Kriteria penerimaan:

1. KP-03.1: Tautan reset berlaku 60 menit dan hanya dapat dipakai satu kali.
2. KP-03.2: Respons halaman permintaan reset sama, baik email terdaftar maupun tidak, sehingga keberadaan akun tidak dapat ditebak.
3. KP-03.3: Setelah password diganti, seluruh sesi lain milik pengguna tersebut berakhir.
4. KP-03.4: Kegagalan layanan email tidak menggagalkan permintaan; email dikirim ulang melalui antrean.

### 6.2 Data Master

#### FR-04 Master Barang

| Atribut | Keterangan |
| --- | --- |
| Deskripsi | Mengelola data barang: kode, nama, satuan, kategori barang, dan status aktif. Setiap varian produk dicatat sebagai barang terpisah |
| Prioritas | Must |
| Status | Asumsi IT |
| Role | Pemilik, Akuntan |

Kriteria penerimaan:

1. KP-04.1: Kode barang unik dan tidak dapat diubah setelah barang memiliki transaksi.
2. KP-04.2: Barang yang memiliki transaksi tidak dapat dihapus; barang tersebut hanya dapat dinonaktifkan.
3. KP-04.3: Barang nonaktif tidak muncul pada pilihan transaksi baru, tetapi tetap muncul pada laporan.

#### FR-05 Master Kategori Kas

| Atribut | Keterangan |
| --- | --- |
| Deskripsi | Mengelola kategori kas masuk dan kas keluar. Daftar awal berasal dari Tim Bisnis |
| Prioritas | Must |
| Status | Asumsi IT |
| Role | Akuntan |

Kriteria penerimaan:

1. KP-05.1: Setiap kategori memiliki jenis, yaitu masuk atau keluar, dan hanya muncul pada transaksi dengan jenis yang sama.
2. KP-05.2: Kategori yang telah dipakai tidak dapat dihapus; kategori tersebut hanya dapat dinonaktifkan.

#### FR-06 Master Kantong Kas

| Atribut | Keterangan |
| --- | --- |
| Deskripsi | Mengelola kantong kas, misalnya kas tunai, rekening bank, dompet digital, dan saldo marketplace |
| Prioritas | Must |
| Status | Asumsi IT |
| Role | Pemilik, Akuntan |

Kriteria penerimaan:

1. KP-06.1: Saldo setiap kantong dihitung dari saldo awal ditambah seluruh mutasi; saldo tidak dapat diinput langsung.
2. KP-06.2: Kantong yang memiliki saldo tidak nol tidak dapat dinonaktifkan.

#### FR-07 Master Pemasok dan Pelanggan

| Atribut | Keterangan |
| --- | --- |
| Deskripsi | Mengelola data sederhana pemasok dan pelanggan: nama, kontak, dan catatan |
| Prioritas | Must |
| Status | Asumsi IT |
| Role | Pemilik, Akuntan |

Kriteria penerimaan:

1. KP-07.1: Pemasok atau pelanggan wajib dipilih pada transaksi kredit dan bersifat opsional pada transaksi tunai.
2. KP-07.2: Pemasok atau pelanggan yang memiliki transaksi tidak dapat dihapus.

### 6.3 Data Awal

#### FR-08 Impor Saldo Awal dan Persediaan Awal

| Atribut | Keterangan |
| --- | --- |
| Deskripsi | Mengimpor saldo awal kantong kas, persediaan awal (kode, nama, jumlah, harga perolehan per unit), serta saldo awal utang dan piutang melalui template Excel pada tanggal cut-off |
| Prioritas | Must |
| Status | Asumsi IT |
| Role | Akuntan |

Kriteria penerimaan:

1. KP-08.1: Sistem menampilkan pratinjau dan seluruh kesalahan validasi sebelum data disimpan.
2. KP-08.2: Impor bersifat semua atau tidak sama sekali; satu baris salah membatalkan seluruh impor.
3. KP-08.3: Jumlah dan harga tidak boleh negatif, dan kode barang tidak boleh ganda.
4. KP-08.4: Impor hanya dapat dilakukan sebelum ada transaksi pertama setelah tanggal cut-off.

### 6.4 Kas

#### FR-09 Kas Masuk dan Kas Keluar

| Atribut | Keterangan |
| --- | --- |
| Deskripsi | Mencatat kas masuk dan kas keluar dengan tanggal, kantong kas, kategori, nominal, dan keterangan |
| Prioritas | Must |
| Status | Terkonfirmasi |
| Role | Pemilik, Pencatat, Akuntan |

Kriteria penerimaan:

1. KP-09.1: Nominal wajib lebih besar dari nol.
2. KP-09.2: Saldo kantong kas diperbarui segera setelah transaksi tersimpan.
3. KP-09.3: Kas keluar yang membuat saldo kantong negatif ditolak dengan pesan yang menyebut saldo tersedia.
4. KP-09.4: Transaksi dengan tanggal pada periode terkunci ditolak.

#### FR-10 Transfer antar Kantong Kas

| Atribut | Keterangan |
| --- | --- |
| Deskripsi | Memindahkan dana antar kantong kas tanpa dicatat sebagai pendapatan atau beban |
| Prioritas | Must |
| Status | Asumsi IT |
| Role | Pemilik, Pencatat, Akuntan |

Kriteria penerimaan:

1. KP-10.1: Kantong asal dan kantong tujuan harus berbeda.
2. KP-10.2: Saldo kantong asal berkurang dan saldo kantong tujuan bertambah dalam satu transaksi database.
3. KP-10.3: Transfer tidak memengaruhi total kas masuk maupun total kas keluar pada laporan kas.

### 6.5 Pembelian dan Penjualan

#### FR-11 Pembelian

| Atribut | Keterangan |
| --- | --- |
| Deskripsi | Mencatat pembelian tunai atau kredit dengan satu atau lebih baris barang (barang, jumlah, harga satuan) dan biaya tambahan seperti ongkos kirim |
| Prioritas | Must |
| Status | Terkonfirmasi untuk penilaian moving average; selebihnya Asumsi IT |
| Role | Pemilik, Pencatat, Akuntan |
| Sequence diagram | SD-03 |

Kriteria penerimaan:

1. KP-11.1: Biaya tambahan dialokasikan ke setiap baris sebanding dengan nilai baris (AB-04).
2. KP-11.2: Biaya rata-rata setiap barang dihitung ulang sesuai AB-01.
3. KP-11.3: Pembelian tunai mengurangi saldo kantong kas yang dipilih; pembelian kredit menambah utang kepada pemasok dan tidak mengubah kas.
4. KP-11.4: Stok, kas atau utang, dan audit trail tersimpan dalam satu transaksi database; kegagalan salah satu membatalkan seluruhnya.

#### FR-12 Penjualan

| Atribut | Keterangan |
| --- | --- |
| Deskripsi | Mencatat penjualan tunai atau kredit dengan satu atau lebih baris barang (barang, jumlah, harga jual setelah potongan) |
| Prioritas | Must |
| Status | Terkonfirmasi untuk HPP moving average; selebihnya Asumsi IT |
| Role | Pemilik, Pencatat, Akuntan |
| Sequence diagram | SD-02 |

Kriteria penerimaan:

1. KP-12.1: HPP setiap baris dihitung otomatis dari biaya rata-rata pada saat transaksi (AB-02).
2. KP-12.2: Baris yang jumlahnya melebihi stok tersedia menolak seluruh transaksi dan menyebut barang serta stok tersedia (AB-03).
3. KP-12.3: Penjualan tunai menambah saldo kantong kas; penjualan kredit menambah piutang pelanggan dan tidak mengubah kas.
4. KP-12.4: Pencatat melihat konfirmasi transaksi tersimpan, tetapi tidak melihat HPP.
5. KP-12.5: Dua penjualan bersamaan atas barang yang sama tidak dapat membuat stok negatif (NFR-03).

#### FR-13 Pelunasan Utang dan Piutang

| Atribut | Keterangan |
| --- | --- |
| Deskripsi | Mencatat pembayaran utang kepada pemasok dan penerimaan piutang dari pelanggan, termasuk pembayaran sebagian. Tanggal jatuh tempo bersifat opsional |
| Prioritas | Must |
| Status | Asumsi IT |
| Role | Pemilik, Pencatat, Akuntan |
| Sequence diagram | SD-04 |

Kriteria penerimaan:

1. KP-13.1: Nominal pelunasan tidak boleh melebihi sisa tagihan.
2. KP-13.2: Kas berubah pada tanggal pelunasan, bukan pada tanggal transaksi kredit.
3. KP-13.3: Tagihan berstatus lunas ketika sisa tagihan mencapai nol.

### 6.6 Persediaan

#### FR-14 Penyesuaian Stok dan Stock Opname

| Atribut | Keterangan |
| --- | --- |
| Deskripsi | Mencatat hasil hitung fisik dan penyesuaian stok karena rusak, hilang, atau selisih, dengan alasan wajib |
| Prioritas | Must |
| Status | Asumsi IT |
| Role | Akuntan |

Kriteria penerimaan:

1. KP-14.1: Akuntan menginput jumlah fisik; sistem menghitung selisih terhadap stok tercatat.
2. KP-14.2: Penyesuaian dinilai dengan biaya rata-rata saat itu (AB-05).
3. KP-14.3: Penyesuaian tidak mengubah kas.

### 6.7 Koreksi dan Periode

#### FR-15 Pembatalan Transaksi dan Transaksi Bertanggal Lampau

| Atribut | Keterangan |
| --- | --- |
| Deskripsi | Koreksi dilakukan dengan membatalkan transaksi lalu menginput transaksi pengganti. Transaksi bertanggal lampau diizinkan pada periode yang belum dikunci dan memicu perhitungan ulang berantai |
| Prioritas | Must |
| Status | Asumsi IT |
| Role | Pemilik, Akuntan; Pencatat untuk transaksi miliknya yang bertanggal hari ini |
| Sequence diagram | SD-05 |

Kriteria penerimaan:

1. KP-15.1: Transaksi tidak dapat diubah atau dihapus; pembatalan membuat catatan pembatalan yang merujuk transaksi asal, dan alasan wajib diisi.
2. KP-15.2: Pembatalan atau transaksi bertanggal lampau memicu perhitungan ulang biaya rata-rata dan HPP seluruh transaksi barang terkait sejak tanggal tersebut (AB-06).
3. KP-15.3: Perubahan ditolak bila perhitungan ulang menghasilkan stok negatif pada titik waktu mana pun, dan sistem menyebut tanggal serta barang penyebabnya.
4. KP-15.4: Pembatalan dan transaksi bertanggal pada periode terkunci ditolak.

#### FR-16 Kunci Periode

| Atribut | Keterangan |
| --- | --- |
| Deskripsi | Akuntan mengunci periode bulanan yang telah diverifikasi, dan dapat membuka kunci dengan alasan tercatat |
| Prioritas | Must |
| Status | Asumsi IT |
| Role | Akuntan |
| Sequence diagram | SD-06 |

Kriteria penerimaan:

1. KP-16.1: Periode hanya dapat dikunci bila seluruh periode sebelumnya sudah terkunci.
2. KP-16.2: Membuka kunci hanya dapat dilakukan pada periode terkunci terakhir, dengan alasan wajib.
3. KP-16.3: Penguncian dan pembukaan kunci tercatat dalam audit trail.

### 6.8 Audit Trail

#### FR-17 Audit Trail

| Atribut | Keterangan |
| --- | --- |
| Deskripsi | Setiap pembuatan, pembatalan, dan perubahan data master, pengguna, serta periode dicatat: siapa, kapan, aksi, objek, data sebelum, dan data sesudah |
| Prioritas | Must |
| Status | Asumsi IT |
| Role | Pemilik, Akuntan (melihat) |

Kriteria penerimaan:

1. KP-17.1: Catatan audit tersimpan dalam transaksi database yang sama dengan perubahan yang dicatat.
2. KP-17.2: Catatan audit tidak dapat diubah atau dihapus oleh role mana pun melalui aplikasi.
3. KP-17.3: Audit trail dapat disaring berdasarkan pengguna, jenis objek, dan rentang tanggal.

### 6.9 Laporan dan Ekspor

#### FR-18 Laporan Kas

| Atribut | Keterangan |
| --- | --- |
| Deskripsi | Laporan kas masuk, kas keluar, dan saldo kas per periode dan per kantong, beserta riwayat transaksi |
| Prioritas | Must |
| Status | Terkonfirmasi (arahan dosen) |
| Role | Pemilik, Akuntan |

Kriteria penerimaan:

1. KP-18.1: Laporan menampilkan saldo awal, total masuk, total keluar, dan saldo akhir untuk rentang tanggal yang dipilih.
2. KP-18.2: Total dapat dirinci per kategori dan per kantong.
3. KP-18.3: Saldo akhir laporan sama dengan saldo kantong pada tanggal yang sama.

#### FR-19 Laporan Persediaan

| Atribut | Keterangan |
| --- | --- |
| Deskripsi | Kartu stok per barang, nilai persediaan per tanggal, dan HPP per periode |
| Prioritas | Should |
| Status | Belum diketahui (rincian menunggu dosen) |
| Role | Pemilik, Akuntan |

Kriteria penerimaan (default sampai rincian diterima):

1. KP-19.1: Kartu stok menampilkan tanggal, nomor referensi, jumlah masuk, jumlah keluar, saldo jumlah, biaya rata-rata, dan saldo nilai.
2. KP-19.2: Total nilai persediaan sama dengan jumlah saldo nilai seluruh barang pada tanggal yang sama.

#### FR-20 Ekspor ke Excel

| Atribut | Keterangan |
| --- | --- |
| Deskripsi | Laporan yang tampil di layar dapat diekspor ke berkas .xlsx |
| Prioritas | Should |
| Status | Asumsi IT |
| Role | Pemilik, Akuntan |

Kriteria penerimaan:

1. KP-20.1: Isi berkas sama dengan laporan di layar untuk filter yang sama.
2. KP-20.2: Nilai uang diekspor sebagai angka, bukan teks.

### 6.10 Retur

#### FR-21 Retur Pembelian dan Penjualan Sederhana

| Atribut | Keterangan |
| --- | --- |
| Deskripsi | Mencatat pengembalian barang yang merujuk transaksi asal, beserta pengembalian dana atau pengurangan tagihan |
| Prioritas | Should |
| Status | Asumsi IT; aturan penilaian perlu konfirmasi Tim Bisnis |
| Role | Pemilik, Akuntan |

Kriteria penerimaan:

1. KP-21.1: Jumlah retur tidak melebihi jumlah pada transaksi asal dikurangi retur sebelumnya.
2. KP-21.2: Penilaian retur mengikuti AB-07.

### 6.11 Keandalan Input

#### FR-22 Pengiriman Ulang Otomatis dan Draf Form

| Atribut | Keterangan |
| --- | --- |
| Deskripsi | Bila pengiriman form gagal karena koneksi, aplikasi mengirim ulang secara otomatis selama aplikasi terbuka. Bila tetap gagal, isian form disimpan sebagai draf di perangkat |
| Prioritas | Could |
| Status | Keputusan Tim IT, 26 Oktober 2026 |
| Role | Semua role yang menginput transaksi |
| Sequence diagram | SD-02 (jalur alternatif) |

Kriteria penerimaan:

1. KP-22.1: Pengiriman ulang memakai idempotency key yang sama, sehingga transaksi tidak tercatat dua kali.
2. KP-22.2: Draf hanya dikirim atas tindakan pengguna; draf tidak pernah dikirim otomatis setelah aplikasi ditutup.
3. KP-22.3: Draf terikat pada pengguna yang membuatnya dan dihapus dari perangkat saat logout.
4. KP-22.4: Validasi stok dan saldo tetap dilakukan server pada saat draf dikirim.

### 6.12 Produksi

#### FR-23 Barang Masuk dari Produksi

| Atribut | Keterangan |
| --- | --- |
| Deskripsi | Mencatat barang jadi hasil produksi sendiri sebagai barang masuk dengan harga pokok per unit yang diinput manual |
| Prioritas | Could; naik menjadi Must bila Tim Bisnis mengonfirmasi mitra memproduksi sendiri |
| Status | Belum diketahui |
| Role | Akuntan |

Kriteria penerimaan:

1. KP-23.1: Barang masuk dari produksi tidak mengubah kas.
2. KP-23.2: Biaya rata-rata dihitung ulang sesuai AB-01 dengan harga pokok yang diinput.

---

## 7. Aturan Bisnis

| ID | Aturan | Status |
| --- | --- | --- |
| AB-01 | Persediaan dinilai dengan metode perpetual moving average. Setiap barang masuk mengubah biaya rata-rata menjadi saldo nilai dibagi saldo jumlah setelah barang masuk | Terkonfirmasi |
| AB-02 | HPP setiap baris penjualan sama dengan jumlah terjual dikali biaya rata-rata saat transaksi, dibulatkan ke Rupiah terdekat. Saldo nilai dikurangi sebesar HPP yang telah dibulatkan | Terkonfirmasi untuk metode; pembulatan Asumsi IT |
| AB-03 | Stok tidak boleh negatif pada titik waktu mana pun. Transaksi yang melanggar ditolak | Asumsi IT |
| AB-04 | Biaya tambahan pembelian, seperti ongkos kirim, menjadi bagian harga perolehan dan dialokasikan ke setiap baris sebanding dengan nilai baris | Asumsi IT |
| AB-05 | Penyesuaian stok dinilai dengan biaya rata-rata saat penyesuaian. Bila stok tercatat nol dan biaya rata-rata tidak tersedia, Akuntan menginput harga per unit secara manual | Asumsi IT |
| AB-06 | Transaksi tidak diubah di tempat. Koreksi dilakukan dengan pembatalan dan transaksi pengganti. Pembatalan atau transaksi bertanggal lampau memicu perhitungan ulang berantai sejak tanggal tersebut sampai transaksi terakhir barang terkait | Asumsi IT |
| AB-07 | Retur penjualan masuk kembali ke stok dengan HPP transaksi asal. Retur pembelian keluar dengan harga perolehan transaksi asal, lalu biaya rata-rata dihitung ulang | Asumsi IT, perlu konfirmasi |
| AB-08 | Periode adalah bulan kalender. Periode terkunci tidak menerima transaksi, pembatalan, maupun perubahan yang bertanggal di dalamnya | Asumsi IT |
| AB-09 | Saldo kantong kas tidak boleh negatif | Asumsi IT |
| AB-10 | Seluruh nilai dicatat dalam Rupiah. Potongan atau biaya marketplace dicatat sebagai kas keluar dengan kategori beban | Asumsi IT |
| AB-11 | Setiap transaksi membentuk jurnal berpasangan di latar belakang berdasarkan pemetaan akun dari Tim Bisnis. Jurnal tidak ditampilkan di versi 1. Bila daftar akun belum tersedia saat modul transaksi dikembangkan, AB-11 ditunda dan sistem berjalan sebagai buku kas dan kartu stok | Asumsi IT, bergantung pada daftar akun |
| AB-12 | Setiap transaksi memiliki nomor referensi unik dengan format jenis, tahun, bulan, dan urutan, misalnya JUAL-2026-11-0001 | Asumsi IT |

---

## 8. Kebutuhan Non-Fungsional

| ID | Aspek | Kebutuhan | Status |
| --- | --- | --- | --- |
| NFR-01 | Waktu respons | Menyimpan transaksi dan menampilkan laporan bulanan selesai di bawah 2 detik pada volume asumsi (bagian 10.1) | Asumsi IT |
| NFR-02 | Ketersediaan | Upaya terbaik dengan target 99% per bulan, tanpa SLA | Asumsi IT |
| NFR-03 | Konsistensi data | Pembaruan kas, stok, dan audit trail dilakukan dalam satu transaksi database dengan penguncian baris barang dan kantong kas. Setiap pengiriman form membawa idempotency key | Asumsi IT |
| NFR-04 | Presisi angka | Nilai uang disimpan sebagai NUMERIC dengan 2 desimal; biaya rata-rata disimpan sebagai NUMERIC dengan 4 desimal. Tipe floating point tidak digunakan | Asumsi IT |
| NFR-05 | Autentikasi | Sesi berbasis cookie httpOnly dan Secure, password minimal 10 karakter, pembatasan percobaan login, sesi berakhir setelah 120 menit tanpa aktivitas, HTTPS wajib | Asumsi IT |
| NFR-06 | Otorisasi | Setiap aksi diperiksa terhadap role di server; menyembunyikan tombol di antarmuka tidak dianggap sebagai pembatasan akses | Asumsi IT |
| NFR-07 | Backup dan pemulihan | Backup harian terenkripsi di luar penyedia hosting. Kehilangan data maksimal 24 jam; pemulihan maksimal 1 hari kerja; uji pemulihan setiap 3 bulan | Asumsi IT |
| NFR-08 | Hosting | VPS Hostinger KVM 2 dengan Docker Compose, dibayar dan dipegang Mitra | Mengikuti dokumen v0.2 |
| NFR-09 | Kompatibilitas | Chrome Android dan desktop dua versi terakhir, serta Safari iOS 16 ke atas. Aplikasi dapat dipasang sebagai PWA | Asumsi IT |
| NFR-10 | Email | Email dikirim melalui layanan email transaksional dan antrean, sehingga kegagalan email tidak menggagalkan transaksi | Asumsi IT |

---

## 9. Batasan dan Keputusan Teknis

Kode pada kolom Rujukan mengacu pada Daftar Keputusan final tanggal 26 Oktober 2026.

| Aspek | Keputusan | Rujukan |
| --- | --- | --- |
| Platform | PWA berbasis web responsif | Dokumen v0.2 |
| Arsitektur | Satu aplikasi Laravel dengan antarmuka React melalui Inertia; logika bisnis pada lapisan Service/Action | C2, C4 |
| Antarmuka pemrograman | Tidak ada API publik; endpoint JSON internal hanya untuk kebutuhan khusus | C3 |
| Database | PostgreSQL | Dokumen v0.2, D5 |
| Autentikasi | Sesi cookie bawaan Laravel | C5 |
| Konsistensi | Transaksi database, penguncian baris, idempotency key | C6 |
| Perhitungan ulang moving average | Sinkron di dalam transaksi database | C7 |
| Audit trail | Tabel audit pada lapisan bersama aplikasi | C8 |
| Perilaku saat koneksi gagal | Pengiriman ulang otomatis dan draf form; tanpa background sync | C9 |
| Laporan | Dihitung saat diminta | C10 |
| Deployment | Docker Compose; production dari tag rilis dengan prinsip build sekali | D3, D4 |
| Email | Resend tier gratis melalui queue worker | D11 |
| Lokalisasi | Antarmuka Bahasa Indonesia, mata uang Rupiah, zona waktu Asia/Jakarta, format tanggal DD/MM/YYYY | Asumsi IT |

---

## 10. Asumsi, Ketergantungan, Risiko, dan Pertanyaan Terbuka

### 10.1 Asumsi

| ID | Asumsi | Dampak bila salah |
| --- | --- | --- |
| AS-01 | Pengguna paling banyak 5 orang | Ukuran server dan matriks hak akses perlu ditinjau |
| AS-02 | Transaksi paling banyak 100 per hari | Perhitungan ulang sinkron (C7) perlu ditinjau |
| AS-03 | Barang paling banyak 500 jenis | Desain impor dan laporan perlu ditinjau |
| AS-04 | Mitra berdagang; barang hasil produksi dicatat dengan harga pokok manual | Modul produksi perlu dirancang (FR-23 naik prioritas) |
| AS-05 | Tersedia pihak yang memegang role Akuntan | Periode tidak pernah dikunci; koreksi tidak terkendali |
| AS-06 | Tier gratis layanan email tetap tersedia dengan batas yang memadai | Perlu layanan berbayar atau penyedia lain |

### 10.2 Ketergantungan

| ID | Ketergantungan | Pihak | Dibutuhkan untuk |
| --- | --- | --- | --- |
| DP-01 | Contoh transaksi berangka, minimal 10 per alur | Tim Bisnis | Pengujian M-01 dan UAT |
| DP-02 | Daftar akun dan pemetaan transaksi | Tim Bisnis | AB-11 |
| DP-03 | Akses DNS virageawie.com | Mitra | Subdomain, TLS, dan record email |
| DP-04 | Pembayaran VPS oleh Mitra | Mitra | Deployment pertama |
| DP-05 | Daftar awal kategori kas | Tim Bisnis | FR-05 |
| DP-06 | Rincian laporan persediaan | Tim Bisnis (dosen) | FR-19 |

### 10.3 Risiko

| ID | Risiko | Kemungkinan | Dampak | Mitigasi |
| --- | --- | --- | --- | --- |
| R-01 | Mitra ternyata memproduksi sendiri, sehingga HPP tidak tepat | Tinggi | Tinggi | Prioritaskan pertanyaan PT-01; siapkan FR-23 |
| R-02 | Data persediaan awal tidak akurat, sehingga input harian tertahan aturan stok negatif | Sedang | Tinggi | Stock opname pada tanggal cut-off; penyesuaian stok oleh Akuntan |
| R-03 | Tidak ada pihak yang memegang role Akuntan | Sedang | Sedang | Pemilik dapat memegang role Akuntan |
| R-04 | Jawaban Tim Bisnis terlambat | Sedang | Sedang | Pengembangan fondasi berjalan lebih dulu; default berlaku setelah tenggat |
| R-05 | Kerusakan VPS menghilangkan aplikasi dan database sekaligus | Rendah | Tinggi | Backup harian terenkripsi di luar penyedia hosting dan uji pemulihan berkala |
| R-06 | Batas tier gratis layanan email berubah | Rendah | Rendah | Pemeriksaan sebelum go-live; driver email dapat diganti melalui konfigurasi |

### 10.4 Pertanyaan Terbuka

| ID | Pertanyaan | Prioritas | Default bila tidak dijawab |
| --- | --- | --- | --- |
| PT-01 | Apakah mitra murni berdagang atau memproduksi sendiri barangnya? | Tinggi | AS-04 |
| PT-02 | Apakah Tim Bisnis dapat menyediakan daftar akun dan pemetaan transaksi? | Tinggi | AB-11 ditunda |
| PT-03 | Dapatkah Tim Bisnis menyediakan contoh transaksi berangka untuk setiap alur? | Tinggi | Tim IT menyusun contoh untuk diverifikasi Tim Bisnis |
| PT-04 | Siapa pemegang akses DNS virageawie.com? | Tinggi | Deployment pertama tertunda |
| PT-05 | Siapa yang akan memegang role Akuntan setelah versi 1 berjalan? | Sedang | Pemilik |
| PT-06 | Bagaimana penilaian retur pembelian dan penjualan? | Sedang | AB-07 |
| PT-07 | Bagaimana aturan pembulatan HPP? | Sedang | AB-02 |
| PT-08 | Apa rincian laporan persediaan yang dibutuhkan? | Sedang | KP-19.1 dan KP-19.2 |

---

## 11. Rencana Rilis dan Penerimaan

### 11.1 Tahapan Rilis

| Tahap | Cakupan | Lingkungan | Syarat masuk |
| --- | --- | --- | --- |
| R0 Fondasi | FR-01, FR-02, FR-03, FR-17, kerangka PWA | Lokal, lalu staging | PRD v0.1 disetujui Tim IT |
| R1 Kas dan data master | FR-04 sampai FR-10, FR-18 | Staging | R0 selesai |
| R2 Transaksi dan persediaan | FR-11 sampai FR-16, FR-19 sampai FR-23 | Staging | PRD v0.2 dikonfirmasi Tim Bisnis per bagian |
| R3 UAT | Seluruh FR Must | Staging dengan data contoh | R2 selesai |
| R4 Go-live | Impor data awal dan pemakaian nyata | Production | UAT lulus |

### 11.2 Definition of Done

Sebuah kebutuhan dianggap selesai bila seluruh syarat berikut terpenuhi.

1. Seluruh kriteria penerimaan terpenuhi.
2. Tes otomatis untuk kriteria penerimaan tersedia dan lulus di CI.
3. Perubahan telah direview oleh anggota tim selain penulisnya.
4. Perubahan data tercatat dalam audit trail bila kebutuhan tersebut mengubah data.
5. Dokumen terkait diperbarui bila terdapat perubahan perilaku.

### 11.3 User Acceptance Test

1. UAT dilakukan oleh Tim Bisnis di lingkungan staging dengan data contoh, bukan data asli mitra.
2. Kasus uji diturunkan dari kriteria penerimaan pada bagian 6.
3. Perhitungan diuji dengan contoh transaksi berangka dari Tim Bisnis (DP-01).
4. UAT dinyatakan lulus bila seluruh kriteria penerimaan berprioritas Must terpenuhi dan tidak ada selisih perhitungan terhadap contoh transaksi.

### 11.4 Persiapan Go-Live

1. Menyepakati tanggal cut-off, disarankan awal bulan.
2. Melakukan stock opname pada tanggal cut-off.
3. Mengisi dan memeriksa template data awal bersama Akuntan.
4. Mengimpor data awal (FR-08) di production.
5. Memastikan backup harian berjalan dan uji pemulihan pertama telah dilakukan.

---

## Lampiran A. Keterlacakan Kebutuhan

| Sequence diagram | Alur | Kebutuhan terkait |
| --- | --- | --- |
| SD-01 | Login dan sesi berakhir | FR-01, NFR-05 |
| SD-02 | Penjualan tunai, termasuk jalur gagal, rollback, dan pengiriman ulang | FR-12, FR-22, AB-02, AB-03, NFR-03 |
| SD-03 | Pembelian tunai dengan biaya tambahan | FR-11, AB-01, AB-04 |
| SD-04 | Pelunasan piutang | FR-13 |
| SD-05 | Pembatalan dan transaksi bertanggal lampau dengan perhitungan ulang | FR-15, AB-06 |
| SD-06 | Kunci periode | FR-16, AB-08 |
| SD-07 | Reset password melalui email | FR-03, NFR-10 |

---

## Lampiran B. Ilustrasi Perhitungan

Angka pada lampiran ini adalah ilustrasi untuk menjelaskan aturan, bukan data mitra.

### B.1 Moving Average dan HPP (AB-01, AB-02, AB-04)

| Langkah | Transaksi | Jumlah | Nilai (Rp) | Saldo jumlah | Saldo nilai (Rp) | Biaya rata-rata (Rp) |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | Persediaan awal 10 unit @ 20.000 | +10 | 200.000 | 10 | 200.000 | 20.000,0000 |
| 2 | Pembelian 20 unit @ 23.000, ongkos kirim 20.000 | +20 | 480.000 | 30 | 680.000 | 22.666,6667 |
| 3 | Penjualan 12 unit | -12 | -272.000 | 18 | 408.000 | 22.666,6667 |

Keterangan:

1. Langkah 2: harga perolehan sama dengan 20 x 23.000 + 20.000 = 480.000.
2. Langkah 3: HPP sama dengan 12 x 22.666,6667 = 272.000,0004, dibulatkan menjadi 272.000. Saldo nilai dikurangi HPP yang telah dibulatkan, sehingga saldo nilai tidak bergeser akibat pembulatan.

### B.2 Alokasi Biaya Tambahan (AB-04)

Pembelian barang A sebanyak 10 unit @ 10.000 (nilai 100.000) dan barang B sebanyak 5 unit @ 60.000 (nilai 300.000), dengan ongkos kirim 40.000.

| Barang | Nilai baris (Rp) | Porsi | Alokasi ongkos kirim (Rp) | Harga perolehan (Rp) | Per unit (Rp) |
| --- | --- | --- | --- | --- | --- |
| A | 100.000 | 25% | 10.000 | 110.000 | 11.000 |
| B | 300.000 | 75% | 30.000 | 330.000 | 66.000 |

Bila alokasi menghasilkan pecahan Rupiah, selisih pembulatan dibebankan pada baris dengan nilai terbesar agar jumlah alokasi sama persis dengan biaya tambahan.
