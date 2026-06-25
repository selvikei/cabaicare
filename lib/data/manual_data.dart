import 'package:flutter/material.dart';

class ManualData {
  static final List<Map<String, dynamic>> data = [
    {
      "id": 1,
      "title": "Fitur Deteksi : Ambil Gambar & Upload",
      "icon": Icons.camera_alt_rounded,
      "steps": [
        {
          "type": "text",
          "content":
              "Fitur deteksi gambar ini digunakan untuk menganalisis foto daun tanaman cabai yang diambil langsung atau dari galeri ponsel secara offline.",
        },
        {
          "type": "image",
          "imagePath": "assets/images/detector_button.png",
        },
        {
          "type": "number",
          "number": "a.",
          "content":
              "Ambil Gambar: Tekan tombol lingkaran putih besar di tengah bawah. Pastikan objek daun terfokus dan diarahkan tepat masuk ke dalam area kotak pemandu.",
        },
        {
          "type": "number",
          "number": "b.",
          "content":
              "Upload Galeri: Tekan tombol ikon galeri di sudut kanan bawah untuk mengunggah berkas foto dari penyimpanan perangkat.",
        },
        {
          "type": "number",
          "number": "c.",
          "content":
              "Ganti Kamera: Tekan tombol rotasi kamera untuk beralih menggunakan sensor kamera depan atau kamera belakang.",
        },
      ]
    },
    {
      "id": 2,
      "title": "Fitur Deteksi Real-Time (Offline)",
      "icon": Icons.videocam_rounded,
      "steps": [
        {
          "type": "text",
          "content":
              "Bounding Box: Kotak pembatas otomatis akan muncul mengelilingi posisi hama. Setiap jenis hama (Kutu Daun, Thrips, Kutu Kebul) memiliki warna kotak yang berbeda beserta akurasi skor numerik.",
        },
        {
          "type": "image",
          "imagePath": "assets/images/real-time_kutu-daun.png",
        },
        {
          "type": "image",
          "imagePath": "assets/images/real-time_kutu_kebul.png",
        },
        {
          "type": "image",
          "imagePath": "assets/images/real-time_thrips.png",
        },
        {
          "type": "text",
          "content":
              "Informasi Deteksi: Di bagian atas layar, terdapat informasi model YOLOv8 yang digunakan, jumlah hama terdeteksi, dan FPS (Frames Per Second) untuk menilai performa deteksi secara real-time.",
        },
        {
          "type": "image",
          "imagePath": "assets/images/real-time_appbar.png",
        },
        {
          "type": "number",
          "number": "a.",
          "content":
              "Model: Menunjukkan nama model YOLOv8 yang digunakan untuk mendeteksi hama. Model ini telah dioptimalkan agar dapat berjalan secara offline di perangkat mobile.",
        },
        {
          "type": "number",
          "number": "b.",
          "content":
              "Jumlah Detection: Menunjukkan total hama yang terdeteksi dalam frame saat ini. Setiap kotak bounding box mewakili satu objek/hama terdeteksi.",
        },
        {
          "type": "number",
          "number": "c.",
          "content":
              "FPS (Frames Per Second): Menunjukkan jumlah frame yang diproses per detik. Semakin tinggi FPS, semakin lancar aliran video dan respons model.",
        },
        {
          "type": "bullet",
          "content":
              "Tombol Kamera: Tombol kontrol di sisi kiri bawah layar memudahkan untuk membalikkan tangkapan kamera depan dan belakang saat pemantauan di lapangan.",
        },
      ]
    },
    {
      "id": 3,
      "title": "Fitur Manajemen Riwayat Lokal",
      "icon": Icons.history_rounded,
      "steps": [
        {
          "type": "image",
          "imagePath": "assets/images/riwayat_simpan.png",
        },
        {
          "type": "text",
          "content":
              "Riwayat Deteksi: Semua hasil deteksi yang disimpan akan muncul di halaman riwayat. Anda dapat meninjau kembali hasil deteksi sebelumnya, termasuk foto, bounding box, dan skor akurasi.",
        },
        {
          "type": "image",
          "imagePath": "assets/images/riwayat_lihat.png",
        },
        {
          "type": "text",
          "content":
              "Hapus Riwayat: Anda dapat menghapus riwayat satu per satu melalui halaman detail seperti pada ikon hapus di halaman detail berikut.",
        },
        {
          "type": "image",
          "imagePath": "assets/images/riwayat_appbar.png",
        },
        // {
        //   "type": "image",
        //   "imagePath": "assets/images/riwayat_screen.png",
        // },
      ]
    },
    {
      "id": 4,
      "title": "Fitur Informasi Komoditas Cabai",
      "icon": Icons.info_rounded,
      "steps": [
        {
          "type": "text",
          "content":
              "Menyajikan rangkuman edukasi dasar mengenai pentingnya nilai ekonomi komoditas hortikultura cabai nasional, tantangan budidaya, serta data statistik konsumsi harian masyarakat Indonesia.",
        },
        {
          "type": "bullet",
          "content":
              "Seluruh data komoditas didukung oleh sumber referensi terpercaya yang dapat divalidasi pada bagian literatur di dasar halaman.",
        },
      ]
    },
    {
      "id": 5,
      "title": "Fitur Informasi Hama & Penyakit",
      "icon": Icons.bug_report_rounded,
      "steps": [
        {
          "type": "text",
          "content":
              "Ensiklopedia digital mini yang memuat deskripsi lengkap mengenai ciri morfologi hama tanaman cabai beserta metode penanggulangan medis tanamannya.",
        },
        {
          "type": "bullet",
          "content":
              "Rekomendasi Pengendalian: Memuat info takaran penggunaan pestisida nabati (organik) maupun bahan aktif kimia selektif yang aman bagi ekosistem lingkungan.",
        },
        {
          "type": "bullet",
          "content":
              "Akurasi Data: Semua deskripsi gejala klinis disarikan langsung dari jurnal ilmiah proteksi tanaman bersitasi resmi.",
        },
      ]
    },
  ];
}
