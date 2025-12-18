<div align="center">
<a href="[https://github.com/Faizarrobbi/ayotani](https://www.google.com/search?q=https://github.com/Faizarrobbi/ayotani)">
<img src="assets/logo.png" alt="Logo AyoTani" width="120" height="120">
</a>

<h1 align="center">AyoTani</h1>

<p align="center">
<b>Platform Digital Pertanian Terpadu Berbasis Multimedia Edukasi & Smart Farming</b>
<br />
<a href="#-tentang-proyek">Tentang</a> •
<a href="#-fitur-unggulan">Fitur</a> •
<a href="#-teknologi">Teknologi</a> •
<a href="#-instalasi">Instalasi</a> •
<a href="#-tim-pengembang">Tim</a>
</p>
</div>

---

## 📖 Tentang Proyek

**AyoTani** adalah aplikasi mobile yang dirancang untuk menjawab tantangan regenerasi petani dan rendahnya literasi teknologi di sektor pertanian Indonesia.

Nama **"AyoTani"** menggabungkan kata *"Ayo"* (ajakan semangat) dan *"Tani"*, membawa filosofi: **"Mari kembali bertani dengan cara yang modern dan cerdas."**

Aplikasi ini berfokus pada **Edukasi Multimedia Adaptif** untuk mengatasi hambatan literasi teks pada petani konvensional, serta menyediakan alat **Monitoring Lahan** berbasis data untuk meningkatkan produktivitas.

## ✨ Fitur Unggulan

### 1. 🎓 Edukasi Multimedia (Core Feature)

Solusi untuk petani dengan tingkat literasi beragam.

* **Video Tutorial Terintegrasi:** Belajar teknik bertani melalui visual (YouTube integration) tanpa harus banyak membaca.
* **Artikel Dinamis:** Materi bacaan yang dikategorikan berdasarkan tingkat kesulitan (*Beginner, Intermediate, Advanced*).

### 2. 🌾 Monitoring Lahan Cerdas

Transformasi dari pertanian intuitif ke *data-driven farming*.

* **Pemetaan Geospasial:** Menandai lokasi lahan secara presisi menggunakan peta interaktif.
* **Log Harian:** Mencatat penyiraman, pemupukan, dan perkembangan tinggi tanaman.
* **Visualisasi Grafik:** Memantau progres pertumbuhan tanaman melalui grafik yang mudah dipahami.

### 3. 🛒 Marketplace Saprodi

Memutus rantai pasok yang tidak efisien.

* **Belanja Kebutuhan Tani:** Akses langsung ke benih, pupuk, dan alat pertanian berkualitas.
* **Manajemen Transaksi:** Fitur keranjang belanja dan simulasi *checkout* yang transparan.

## 🛠 Teknologi

Project ini dibangun menggunakan pendekatan **Clean Architecture** untuk memastikan skalabilitas dan *maintainability* kode.

| Kategori | Teknologi | Deskripsi |
| --- | --- | --- |
| **Framework** |  | Multi-platform (Android/iOS) UI Toolkit |
| **Language** | !([https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white](https://www.google.com/search?q=https://img.shields.io/badge/dart-%25230175C2.svg%3Fstyle%3Dfor-the-badge%26logo%3Ddart%26logoColor%3Dwhite)) | Bahasa pemrograman utama |
| **Backend** | !([https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)) | Database (PostgreSQL), Auth, & Storage |
| **State Mgt** | **Provider** | Manajemen state aplikasi yang efisien |
| **Maps** | **flutter_map** | Integrasi OpenStreetMap untuk geospasial |

## 📂 Struktur Proyek (Clean Architecture)bash
```
lib/
├── common/            # Konstanta, Gaya (Themes), dan Widget Reusable
├── data/              # Layer Data (API Calls, Models, Repositories Impl)
│   ├── datasources/   # Koneksi langsung ke Supabase
│   ├── models/        # Representasi data (JSON parsing)
│   └── repositories/  # Implementasi kontrak repositori
├── domain/            # Layer Bisnis (Entities, Usecases, Repository Interfaces)
│   ├── entities/      # Objek bisnis murni
│   └── repositories/  # Kontrak (Abstract Class)
├── presentation/      # Layer Tampilan (UI)
│   ├── pages/         # Halaman-halaman aplikasi (Screen)
│   ├── providers/     # State management logic
│   └── widgets/       # Komponen UI spesifik
└── main.dart          # Entry point

```

## 🚀 Instalasi

Ikuti langkah ini untuk menjalankan proyek di lokal komputer Anda:

1.  **Clone Repositori**
    ```bash
    git clone [https://github.com/Faizarrobbi/ayotani.git](https://github.com/Faizarrobbi/ayotani.git)
    cd ayotani
    ```

2.  **Install Dependencies**
    Pastikan Flutter SDK sudah terinstall.
    ```bash
    flutter pub get
    ```

3.  **Konfigurasi Environment**
    Buat file `.env` di root project dan masukkan kredensial Supabase Anda (jika diperlukan oleh kode):
    ```env
    SUPABASE_URL=your_supabase_url
    SUPABASE_ANON_KEY=your_supabase_anon_key
    ```

4.  **Jalan Aplikasi**
    ```bash
    flutter run
    ```

## 👥 Tim Pengembang

Proyek ini dikembangkan oleh **Kelompok 09 - Kelas B** Departemen Sistem Informasi ITS sebagai Laporan Proyek Akhir.

| Nama | NRP |
| :--- | :--- |
| **Muhammad Fiqih Soetam Putra** | 5026231096 |
| **Akhtar Zia Faizarrobbi** | 5026231095 |
| **Felix Prajna Santoso** | 5026231027 |
| **Harbima Razan Adhitya** | 5026231225 |
| **Lita Sari Banjanahor** | 5026231029 |
| **Michelle Lea Amanda** | 5026231214 |

---
<div align="center">
  <small>Dikembangkan dengan ❤️ untuk Pertanian Indonesia</small>
</div>