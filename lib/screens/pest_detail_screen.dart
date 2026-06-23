import 'package:flutter/material.dart';
import '../widgets/appbar_widget.dart';

class PestDetailScreen extends StatelessWidget {
  final String name;
  final String description;
  final String imagePath;
  final List<String> sources;
  final List<String> pesticides; // Koreksi penulisan variabel menjadi benar

  const PestDetailScreen({
    super.key,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.sources,
    required this.pesticides, // Wajib ditambahkan di dalam parameter constructor
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Informasi $name",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Gambar Utama Fitur Hama
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),

              // 2. Label Definisi & Gejala Serangan
              const SectionTag(label: "Definisi & Gejala"),
              const SizedBox(height: 12),

              // Teks Deskripsi Ringkasan Buku TA
              Text(
                description,
                textAlign: TextAlign.justify, // Dibuat rata kanan-kiri agar lebih formal
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 25),

              // ========================================================
              // 3. BLOK BARU: CARA PENGENDALIAN / PESTISIDA
              // ========================================================
              const SectionTag(label: "Cara Pengendalian & Pestisida"),
              const SizedBox(height: 12),
              
              ...pesticides.map(
                (pesticide) => Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F7F7), // Latar belakang abu kehijauan tipis CabaiCare
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE0EBEB)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.gavel_rounded, // Ikon eksekusi penanggulangan medis tanaman
                          size: 16, 
                          color: Color(0xFF2E5959),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            pesticide,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ).toList(),
              const SizedBox(height: 15),

              // ========================================================
              // 4. BAGIAN SUMBER DATA (SITASI LITERATUR BUKU)
              // ========================================================
              const SectionTag(label: "Sumber Data"),
              const SizedBox(height: 12),

              ...sources.map(
                (source) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "• ",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2E5959)),
                      ),
                      Expanded(
                        child: Text(
                          source,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: Color.fromARGB(255, 80, 80, 80),
                            fontStyle: FontStyle.italic, // Sesuai format sitasi akademik asli
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ).toList(),
              const SizedBox(height: 40), // Jarak aman di dasar scroll view
            ],
          ),
        ),
      ),
    );
  }
}

// Widget Komponen Label Tag Pendukung
class SectionTag extends StatelessWidget {
  final String label;
  const SectionTag({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2E5959), // Konsistensi Tema Utama Hijau Gelap CabaiCare
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