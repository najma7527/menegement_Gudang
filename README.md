# 📦 gstok — Aplikasi Manajemen Gudang

> **gstok** adalah aplikasi manajemen gudang yang membantu pengguna mengelola data persediaan secara terpusat.
> Aplikasi ini dirancang untuk memudahkan pencatatan barang, pengelompokan kategori, pemantauan perubahan stok, hingga pembuatan laporan transaksi.

---

## ✨ Tentang gstok

**gstok** dibuat untuk memudahkan proses pencatatan dan pemantauan aktivitas gudang.

Dengan aplikasi ini, pengguna dapat:

* 📦 Mengetahui kondisi stok terkini
* 📥 Mencatat barang masuk
* 📤 Mencatat barang keluar
* 📊 Memantau perubahan stok
* 🧾 Melihat ringkasan transaksi
* 📄 Membuat dan mencetak laporan

Semua proses tersebut dapat dilakukan secara terpusat tanpa harus melakukan pencatatan secara manual.

---

## 🚀 Fitur Utama

### 👤 Autentikasi & Profil

* Registrasi pengguna
* Login pengguna
* Pengelolaan profil pengguna

### 📊 Dashboard

* Ringkasan jumlah barang
* Ringkasan jumlah kategori
* Ringkasan transaksi barang masuk
* Ringkasan transaksi barang keluar

### 📦 Manajemen Barang

* Tambah data barang
* Lihat detail barang
* Ubah data barang
* Hapus data barang
* Pencarian barang

### 🏷️ Manajemen Kategori

* Pengelolaan kategori barang
* Deskripsi kategori
* Pilihan warna kategori

### 🔄 Transaksi Stok

* Pencatatan barang masuk
* Pencatatan barang keluar
* Pembaruan stok secara otomatis berdasarkan transaksi

### 🔔 Notifikasi

* Peringatan ketika stok berada pada kondisi kritis
* Notifikasi untuk membantu pengguna memantau kondisi persediaan

### 📑 Laporan

* Detail barang
* Detail kategori
* Detail transaksi
* Penyaringan laporan berdasarkan:

  * Harian
  * Mingguan
  * Bulanan
  * Rentang tanggal tertentu
* Pembuatan laporan transaksi dalam format PDF
* Pencetakan laporan transaksi

### 💻 Responsif & Cross-Platform

* Tampilan responsif untuk berbagai ukuran layar
* Dukungan **Flutter Web**

---

## 🛠️ Teknologi yang Digunakan

| Teknologi                          | Penggunaan                                         |
| ---------------------------------- | -------------------------------------------------- |
| 🐦 **Flutter**                     | Framework untuk membangun aplikasi lintas platform |
| 🎯 **Dart**                        | Bahasa pemrograman                                 |
| 🔄 **Provider**                    | Pengelolaan state aplikasi                         |
| 🌐 **HTTP & Dio**                  | Komunikasi dengan REST API                         |
| ⚙️ **Laravel**                     | Framework backend API                              |
| 💾 **Shared Preferences**          | Penyimpanan data lokal aplikasi                    |
| 🔔 **Flutter Local Notifications** | Notifikasi aplikasi                                |
| 🔐 **Permission Handler**          | Pengelolaan izin perangkat                         |
| 📄 **PDF**                         | Pembuatan laporan PDF                              |
| 🖨️ **Printing**                   | Pencetakan laporan                                 |
| 📅 **Intl**                        | Pemformatan tanggal dan mata uang                  |
| 🖼️ **Image Picker**               | Pemilihan gambar                                   |
| 📁 **File Picker**                 | Pemilihan berkas                                   |
| 🔗 **URL Launcher**                | Membuka tautan                                     |

---

## 🔗 Backend API

gstok terhubung dengan **REST API** yang dibuat menggunakan framework **Laravel**.

Source code backend dapat dilihat pada repository berikut:

👉 **[API Management Gudang](https://github.com/najma7527/API_menegement_Gudang)**

---

## 📁 Struktur Project

```text
lib/
├── presentation/
│   ├── screens/
│   ├── widgets/
│   └── providers/
│
├── data/
│   ├── models/
│   └── repositories/
│
├── domain/
│   └── entities/
│
├── core/
│   ├── constants/
│   ├── config/
│   ├── utils/
│   └── network/
│
└── services/
    └── notifications/

assets/
└── images/
```

### 📌 Penjelasan

* `lib/presentation` — layar aplikasi, widget, dan provider.
* `lib/data` — model serta repository untuk mengakses API.
* `lib/domain` — entity aplikasi.
* `lib/core` — konstanta, konfigurasi, utilitas, dan jaringan.
* `lib/services` — layanan notifikasi dan kebutuhan aplikasi lainnya.
* `assets/images` — aset gambar dan logo aplikasi.

---

## ⚙️ Menjalankan Project

Pastikan **Flutter** dan **Dart** sudah terpasang pada perangkat.

### 1. Clone Repository

```bash
git clone <repository-url>
cd gstok
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Konfigurasi API

Sesuaikan konfigurasi **URL API** pada project agar aplikasi dapat terhubung dengan backend.

### 4. Jalankan Aplikasi

```bash
flutter run
```

---

## 🔌 Alur Aplikasi

```text
┌───────────────┐
│   Flutter App │
└───────┬───────┘
        │
        │ REST API
        ▼
┌───────────────┐
│ Laravel API   │
└───────┬───────┘
        │
        ▼
┌───────────────┐
│ Data Gudang   │
└───────────────┘
```

Aplikasi Flutter berkomunikasi dengan **Laravel REST API** untuk mengelola data barang, kategori, stok, dan transaksi.

---

## 📌 Ringkasan

**gstok** menyediakan berbagai kebutuhan dasar manajemen gudang dalam satu aplikasi, mulai dari pengelolaan barang dan kategori, pencatatan transaksi, pemantauan stok, notifikasi stok kritis, hingga pembuatan laporan dalam format PDF.

Dengan dukungan **Flutter Web**, aplikasi juga dapat digunakan pada berbagai ukuran layar.

---

## 👩‍💻 Developer

**Najma**

📌 Project: **gstok — Aplikasi Manajemen Gudang**

---

<p align="center">
  <b>📦 gstok</b><br>
  <i>Manage Stock. Manage Warehouse. Make It Simple.</i>
</p>
