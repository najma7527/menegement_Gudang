# gstok

gstok adalah aplikasi manajemen gudang yang membantu pengguna mengelola data
persediaan secara terpusat. Aplikasi ini dapat digunakan untuk mencatat barang,
mengelompokkan barang berdasarkan kategori, memantau perubahan stok, dan membuat
laporan transaksi.

## Untuk Apa Aplikasi Ini?

gstok dibuat untuk memudahkan proses pencatatan dan pemantauan aktivitas gudang.
Dengan aplikasi ini, pengguna dapat mengetahui kondisi stok terkini, mencatat
barang masuk dan keluar, serta memperoleh ringkasan transaksi tanpa harus
melakukan pencatatan manual.

## Fitur Utama

- Registrasi, login, dan pengelolaan profil pengguna.
- Dashboard ringkasan jumlah barang, kategori, serta transaksi masuk dan keluar.
- Pengelolaan data barang dengan operasi tambah, lihat, ubah, hapus, dan pencarian.
- Pengelolaan kategori barang, termasuk deskripsi dan pilihan warna kategori.
- Pencatatan transaksi barang masuk dan barang keluar.
- Pembaruan stok barang secara otomatis berdasarkan transaksi.
- Peringatan dan notifikasi ketika stok barang berada pada kondisi kritis.
- Detail barang, kategori, dan transaksi.
- Penyaringan laporan transaksi berdasarkan periode harian, mingguan, bulanan,
	atau rentang tanggal tertentu.
- Pembuatan dan pencetakan laporan transaksi dalam format PDF.
- Tampilan responsif untuk berbagai ukuran layar dan dukungan Flutter Web.

## Teknologi yang Digunakan

- **Flutter** sebagai framework untuk membangun aplikasi lintas platform.
- **Dart** sebagai bahasa pemrograman.
- **Provider** untuk pengelolaan state aplikasi.
- **HTTP** dan **Dio** untuk komunikasi dengan REST API.
- **Laravel** sebagai framework backend API.
- **Shared Preferences** untuk penyimpanan data lokal aplikasi.
- **Flutter Local Notifications** dan **Permission Handler** untuk notifikasi
	serta pengelolaan izin perangkat.
- **PDF** dan **Printing** untuk membuat serta mencetak laporan transaksi.
- **Intl** untuk pemformatan tanggal dan mata uang.
- **Image Picker**, **File Picker**, dan **URL Launcher** untuk kebutuhan media,
	berkas, serta pembukaan tautan.

## Backend API

gstok terhubung dengan backend REST API yang dibuat menggunakan framework
Laravel. Source code backend dapat dilihat di repository berikut:

[API Management Gudang](https://github.com/najma7527/API_menegement_Gudang)

## Struktur Singkat

- `lib/presentation`: layar aplikasi, widget, dan provider.
- `lib/data`: model serta repository untuk mengakses API.
- `lib/domain`: entity aplikasi.
- `lib/core`: konstanta, konfigurasi, utilitas, dan jaringan.
- `lib/services`: layanan notifikasi dan kebutuhan aplikasi lainnya.
- `assets/images`: aset gambar dan logo aplikasi.

## Menjalankan Proyek

Pastikan Flutter dan Dart sudah terpasang, lalu jalankan perintah berikut:

```bash
flutter pub get
flutter run
```

Sesuaikan konfigurasi URL API pada project sebelum menjalankan aplikasi agar
aplikasi dapat terhubung ke backend.
