# Glosarium

Padanan istilah bisnis dengan nama yang dipakai di kode. Nama di kode menggunakan bahasa Inggris dan dipakai secara konsisten untuk nama kelas, tabel, kolom, rute, dan variabel. Teks antarmuka tetap menggunakan istilah bisnis dalam Bahasa Indonesia.

| Istilah bisnis | Nama di kode | Keterangan |
| --- | --- | --- |
| Kas masuk | `cash_in` | Transaksi penerimaan uang ke kantong kas |
| Kas keluar | `cash_out` | Transaksi pengeluaran uang dari kantong kas |
| Kantong kas | `cash_account` | Tempat penyimpanan uang, misalnya kas tunai atau rekening bank |
| Kategori kas | `cash_category` | Pengelompokan kas masuk dan kas keluar untuk laporan |
| Barang | `item` | Barang dagangan atau bahan yang dicatat persediaannya |
| Pemasok | `supplier` | Pihak yang menjual barang kepada usaha |
| Pelanggan | `customer` | Pihak yang membeli barang dari usaha |
| Pembelian | `purchase` | Transaksi pengadaan barang dari pemasok |
| Penjualan | `sale` | Transaksi penjualan barang kepada pelanggan |
| Pelunasan | `settlement` | Pembayaran atas utang pembelian atau piutang penjualan |
| HPP (harga pokok penjualan) | `cost_of_goods_sold` | Biaya barang yang terjual, dihitung dari biaya rata-rata dan dibulatkan ke Rupiah terdekat |
| Biaya rata-rata | `average_cost` | Biaya per unit dengan metode rata-rata bergerak (4 desimal) |
| Penyesuaian stok | `stock_adjustment` | Koreksi jumlah persediaan dengan alasan tertentu |
| Stock opname | `stock_count` | Penghitungan fisik persediaan untuk dicocokkan dengan catatan |
| Retur | `return` | Pengembalian barang dari pelanggan atau kepada pemasok |
| Pembatalan | `reversal` | Transaksi pembalik untuk mengoreksi transaksi lain; transaksi asli tidak diubah atau dihapus |
| Kunci periode | `period_lock` | Penutupan periode sehingga transaksi pada periode tersebut tidak dapat ditambah atau diubah |
| Data awal | `opening_balance` | Saldo kas dan persediaan saat aplikasi mulai digunakan |
| Audit trail | `audit_log` | Catatan siapa melakukan apa dan kapan atas setiap perubahan data |
| Nomor referensi | `reference_number` | Nomor unik yang tercetak pada setiap transaksi |
