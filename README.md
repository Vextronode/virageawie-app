# VIRAGEAWIE

Aplikasi web progresif (PWA) untuk pencatatan kas dan persediaan barang. Aplikasi dibangun dengan Laravel 13, Inertia, React, TypeScript, dan Tailwind CSS, serta menggunakan basis data PostgreSQL 18. Seluruh antarmuka menggunakan Bahasa Indonesia, zona waktu Asia/Jakarta, dan mata uang Rupiah.

## Struktur folder

| Folder | Isi |
| --- | --- |
| `src/` | Aplikasi Laravel (backend, halaman Inertia React, pengujian) |
| `src/app/Domain/<Modul>/` | Logika bisnis per modul (`Actions`, `Services`, `Data`, `Enums`, `Exceptions`) |
| `src/app/Models/` | Model Eloquent |
| `src/tests/` | Pengujian Pest (`Unit`, `Feature`, `Arch`, `Fixtures/golden`) |
| `infra/` | Dockerfile, berkas Compose, konfigurasi Caddy, dan skrip cadangan basis data |
| `docs/` | Dokumen produk, diagram, ADR, dan glosarium |
| `.github/` | Alur kerja CI/CD, templat pull request, dan CODEOWNERS |

## Kebutuhan

- PHP 8.4 dengan ekstensi `pdo_pgsql`, `intl`, `bcmath`, dan `zip`
- Composer 2
- Node.js 24 LTS dan npm (lihat `src/.nvmrc`)
- Docker dengan Compose v2

## Persiapan lokal

1. Jalankan layanan pendukung (PostgreSQL 18 dan Mailpit) dari folder akar repositori:

   ```bash
   docker compose -f infra/compose.local.yaml up -d
   ```

   Basis data `virageawie` untuk pengembangan dan `virageawie_test` untuk pengujian dibuat otomatis. Mailpit dapat dibuka di <http://localhost:8025>.

2. Pasang dependensi dan siapkan aplikasi di folder `src/`:

   ```bash
   cd src
   cp .env.example .env
   composer install
   npm ci
   php artisan key:generate
   php artisan migrate
   ```

3. Jalankan aplikasi:

   ```bash
   composer dev
   ```

## Perintah pengujian dan pemeriksaan

Seluruh perintah dijalankan dari folder `src/`.

| Perintah | Fungsi |
| --- | --- |
| `composer test` | Menjalankan seluruh pengujian Pest, termasuk pengujian arsitektur |
| `vendor/bin/pest --filter=<nama>` | Menjalankan pengujian tertentu |
| `composer lint` | Memeriksa gaya kode PHP dengan Laravel Pint |
| `composer format` | Merapikan gaya kode PHP |
| `composer analyse` | Analisis statis dengan Larastan (level 6) |
| `npm run lint` | Memeriksa kode TypeScript dan React |
| `npm run format:check` | Memeriksa format kode frontend |
| `npm run types` | Pemeriksaan tipe TypeScript |
| `npm run build` | Membangun aset produksi |

## Cabang dan konvensi commit

- `main` berisi kode yang siap rilis. `dev` adalah cabang integrasi.
- Cabang kerja dibuat dari `dev` dengan awalan `feat/`, `fix/`, `refactor/`, `chore/`, atau `docs/`, misalnya `feat/kas-masuk`.
- Perbaikan darurat dibuat dari `main` dengan awalan `hotfix/`, lalu digabungkan kembali ke `main` dan `dev`.
- Pesan commit dan judul pull request mengikuti Conventional Commits, misalnya:
  - `feat(cash): tambah formulir kas masuk`
  - `fix(inventory): perbaiki pembulatan HPP`
  - `refactor!: ubah struktur modul pembelian`
- Satu pull request untuk satu kebutuhan fungsional (FR) atau satu perbaikan.
- CI berjalan pada pull request ke `dev` dan `main`, pada push ke `dev`, dan pada tag rilis `vX.Y.Z` di `main`.

## Rilis

1. Tag `vX.Y.Z` pada `main` membangun citra kontainer satu kali dan memasangnya ke staging.
2. Setelah diverifikasi di staging, citra yang sama dipromosikan ke produksi melalui alur kerja manual "Deploy production".

## Dokumentasi

Dokumen proyek tersedia di folder [`docs/`](docs/):

- [`docs/prd/`](docs/prd/) untuk dokumen kebutuhan produk
- [`docs/diagram/`](docs/diagram/) untuk diagram
- [`docs/adr/`](docs/adr/) untuk catatan keputusan arsitektur
- [`docs/glossary.md`](docs/glossary.md) untuk padanan istilah bisnis dan nama di kode
