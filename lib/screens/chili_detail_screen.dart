import 'package:flutter/material.dart';
import '../widgets/appbar_widget.dart';

class ChiliDetailScreen extends StatelessWidget {
  const ChiliDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: "Informasi Cabai",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Gambar Utama Komoditas Cabai
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  "assets/images/chili_header.jpg", // Sesuaikan path gambar cabai milikmu
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),

              // 2. Judul Utama & Definisi Komoditas
              const SectionTag(label: "Pentingnya Komoditas Cabai"),
              const SizedBox(height: 12),
              const Text(
                "Cabai merupakan salah satu komoditas hortikultura penting di Indonesia yang memiliki nilai ekonomi tinggi dan menjadi bagian tak terpisahkan dari konsumsi harian masyarakat.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'Inter', 
                  fontSize: 14, 
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 25),

              // 3. Blok Tabel Konsumsi Nasional
              const SectionTag(label: "Data Konsumsi Nasional (2023)"),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE0EBEB)),
                ),
                clipBehavior: Clip.antiAlias,
                child: Table(
                  border: TableBorder.symmetric(
                    inside: BorderSide(color: Colors.grey.shade200, width: 1),
                  ),
                  children: [
                    _buildTableRow("Jenis Cabai", "Konsumsi (kg/kapita)", isHeader: true),
                    _buildTableRow("Cabai Besar", "2,42"),
                    _buildTableRow("Cabai Rawit", "2,19"),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "*Sumber: Bapanas / Katadata (2024)",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11, 
                  fontStyle: FontStyle.italic, 
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 25),

              // 4. Blok Tantangan Produksi
              const SectionTag(label: "Tantangan Produksi Hama"),
              const SizedBox(height: 12),
              const Text(
                "Produksi cabai sering kali menghadapi kendala serius akibat serangan organisme pengganggu tanaman (OPT), terutama hama seperti kutu daun (Aphids), thrips, dan kutu kebul (Bemisia tabaci). Hama-hama tersebut menyerang bagian daun, batang, dan buah sehingga dapat menurunkan kualitas maupun kuantitas hasil panen.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'Inter', 
                  fontSize: 14, 
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Serangan thrips misalnya, menyebabkan daun menggulung dan buah gagal tumbuh optimal sehingga menghambat produktivitas tanaman.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'Inter', 
                  fontSize: 14, 
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 25),

              // 5. Blok Solusi Sistem Cerdas Deep Learning
              const SectionTag(label: "Solusi Teknologi Pintar"),
              const SizedBox(height: 12),
              const Text(
                "Dibutuhkan sistem deteksi hama berbasis teknologi, seperti model berbasis deep learning, untuk mempercepat proses identifikasi dan mendukung pengendalian hama secara tepat sasaran demi menjaga kelestarian lingkungan serta kesehatan manusia.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'Inter', 
                  fontSize: 14, 
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),

              // ========================================================
              // 6. BAGIAN REFERENSI & SUMBER DATA AKADEMIK
              // ========================================================
              const SectionTag(label: "Sumber Data & Literatur"),
              const SizedBox(height: 12),
              
              _buildReference("Gambar: Kampus Tani. Cara Budidaya Cabai Di Polybag."),
              _buildReference("Yasen, N., dkk. (2023). Pemanfaatan YOLO untuk Deteksi Hama dan Penyakit pada Daun Cabai Menggunakan Metode Deep Learning. Elektron: Jurnal Ilmiah."),
              _buildReference(" Wardhana, I. M. A., & Wibawa, G. A. (2022). Klasifikasi Jenis Hama pada Tanaman Cabai Menggunakan Metode CNN dan YOLOv5. Jurnal Teknologi Pertanian Unud."),
              _buildReference("Katadata Databoks. (2024). Konsumsi Cabai per Kapita Indonesia Naik, Rekor Tertinggi pada 2023."),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(String col1, String col2, {bool isHeader = false}) {
    return TableRow(
      decoration: BoxDecoration(
        color: isHeader ? const Color(0xFFF4F7F7) : Colors.white,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            col1, 
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              color: isHeader ? const Color(0xFF2E5959) : Colors.black87,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            col2, 
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              color: isHeader ? const Color(0xFF2E5959) : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReference(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "• ",
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2E5959)),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12, 
                color: Color.fromARGB(255, 80, 80, 80),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget Komponen Label Tag Pendukung (Sama dengan Detail Pest)
class SectionTag extends StatelessWidget {
  final String label;
  const SectionTag({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2E5959), // Warna Teal robopest/cabai-care
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Inter',
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}