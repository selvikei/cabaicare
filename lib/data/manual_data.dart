import 'package:flutter/material.dart';

class ManualData {
  static final List<Map<String, dynamic>> data = [
    {
      "id": 1,
      "title": "Fitur Deteksi : Uji Gambar & Upload",
      "icon": Icons.camera_alt_rounded,
      "steps": [
        {
          "type": "text",
          "content": "Gunakan menu uji gambar ini untuk menganalisis foto daun tanaman cabai yang diambil langsung atau dari galeri ponsel secara offline.",
        },
        {
          "type": "image",
          "imagePath": "assets/images/manual_deteksi_gambar.jpg",
        },
        {
          "type": "number",
          "number": "1.",
          "content": "Cara Upload: Tekan tombol ikon galeri di sudut kanan bawah untuk mengunggah berkas foto dari penyimpanan perangkat.",
        },
        {
          "type": "number",
          "number": "2.",
          "content": "Ganti Kamera: Tekan tombol rotasi kamera untuk beralih menggunakan sensor kamera depan atau kamera belakang.",
        },
        {
          "type": "number",
          "number": "3.",
          "content": "Ambil Gambar: Tekan tombol lingkaran putih besar di tengah bawah. Pastikan objek daun terfokus dan diarahkan tepat masuk ke dalam area kotak pemandu.",
        },
      ]
    },
    {
      "id": 2,
      "title": "Fitur Deteksi Real-Time (Offline)",
      "icon": Icons.videocam_rounded,
      "steps": [
        {
          "type": "bullet",
          "content": "Penjelasan Model & FPS: Aliran kamera langsung akan mendeteksi objek hama tanpa jeda jepretan secara offline. Nilai FPS (Frames Per Second) menunjukkan tingkat kelancaran pemrosesan model kecerdasan buatan, sedangkan jumlah detection menunjukkan total hama yang tertangkap.",
        },
        {
          "type": "bullet",
          "content": "Bounding Box: Kotak pembatas otomatis akan muncul mengelilingi posisi hama. Setiap jenis hama (Kutu Daun, Thrips, Kutu Kebul) memiliki warna kotak yang berbeda beserta akurasi skor numerik.",
        },
        {
          "type": "bullet",
          "content": "Tombol Kamera: Tombol kontrol di sisi layar memudahkan Anda membalikkan tangkapan kamera depan dan belakang saat pemantauan di lapangan.",
        },
      ]
    },
    {
      "id": 3,
      "title": "Fitur Informasi Komoditas Cabai",
      "icon": Icons.info_rounded,
      "steps": [
        {
          "type": "text",
          "content": "Menyajikan rangkuman edukasi dasar mengenai pentingnya nilai ekonomi komoditas hortikultura cabai nasional, tantangan budidaya, serta data statistik konsumsi harian masyarakat Indonesia.",
        },
        {
          "type": "bullet",
          "content": "Seluruh data komoditas didukung oleh sumber referensi terpercaya yang dapat divalidasi pada bagian literatur di dasar halaman.",
        },
      ]
    },
    {
      "id": 4,
      "title": "Fitur Informasi Hama & Penyakit",
      "icon": Icons.bug_report_rounded,
      "steps": [
        {
          "type": "text",
          "content": "Ensiklopedia digital mini yang memuat deskripsi lengkap mengenai ciri morfologi hama tanaman cabai beserta metode penanggulangan medis tanamannya.",
        },
        {
          "type": "bullet",
          "content": "Rekomendasi Pengendalian: Memuat info takaran penggunaan pestisida nabati (organik) maupun bahan aktif kimia selektif yang aman bagi ekosistem lingkungan.",
        },
        {
          "type": "bullet",
          "content": "Akurasi Data: Semua deskripsi gejala klinis disarikan langsung dari jurnal ilmiah proteksi tanaman bersitasi resmi.",
        },
      ]
    },
    {
      "id": 5,
      "title": "Fitur Manajemen Riwayat Lokal",
      "icon": Icons.history_rounded,
      "steps": [
        {
          "type": "bullet",
          "content": "Penyimpanan Hasil: Setelah menekan tombol simpan pada halaman hasil deteksi, sistem otomatis menyimpan riwayat scan ke memori lokal tanpa membutuhkan jaringan internet.",
        },
        {
          "type": "bullet",
          "content": "Data Tersimpan: Berkas yang diamankan meliputi dokumen foto, koordinat kotak bounding box, penanda waktu (hari & jam), serta confidence score akurasi model.",
        },
        {
          "type": "bullet",
          "content": "Hapus Riwayat: Anda dapat menghapus data riwayat satu per satu melalui halaman detail, atau membersihkan seluruh database riwayat sekaligus melalui tombol hapus massal yang tersedia.",
        },
      ]
    },
  ];
}