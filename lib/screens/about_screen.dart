import 'package:flutter/material.dart';
import '../widgets/appbar_widget.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Tentang Aplikasi"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            
            // ========================================================
            // IDENTITAS TRADEMARK (LOGO & VERSI)
            // ========================================================
            Center(
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: const Color(0xFFE9EFEF),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]
                ),
                padding: const EdgeInsets.all(16),
                child: Image.asset(
                  'assets/images/cabaicare.png', // Logo resmi CabaiCare
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "CabaiCare",
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E5959),
                letterSpacing: 0.5,
              ),
            ),
            Text(
              "Versi 1.0.0 (2026)",
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            const Divider(color: Color(0xFFE0EBEB)),
            const SizedBox(height: 16),

            // ========================================================
            // DESKRIPSI RISET TEKNIS / ABSTRAK PRODUK
            // ========================================================
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Deskripsi Sistem",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF2E5959),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "CabaiCare adalah aplikasi agrikultur digital cerdas yang dirancang khusus untuk membantu para petani mendeteksi serangan hama pada tanaman cabai secara dini. \n\nAplikasi ini mengintegrasikan model Computer Vision berbasis neural network YOLOv8 (You Only Look Once) yang telah dikuantisasi ke dalam format INT8 untuk memastikan proses inferensi berjalan ringan, mandiri, dan real-time langsung di dalam perangkat keras mobile tanpa memerlukan koneksi internet.",
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: Colors.grey[800],
                height: 1.6,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),

            // ========================================================
            // KARTU INFORMASI PENGEMBANG (FORMAL AKADEMIS)
            // ========================================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F7F7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0EBEB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Informasi Pengembang",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF2E5959),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildMetaRow(Icons.person_rounded, "Nama", "Selvi Riska"),
                  _buildMetaRow(Icons.school_rounded, "Institusi", "Politeknik Elektronika Negeri Surabaya"),
                  _buildMetaRow(Icons.code_rounded, "GitHub", "@selvikei"),
                  _buildMetaRow(Icons.workspace_premium_rounded, "Status Proyek", "Proyek Akhir"),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // FOOTER TRADEMARK HUKUM KAMPUS
            Text(
              "© 2026 CabaiCare Team · PENS. All Rights Reserved.",
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk baris data informasi agar rapi lurus ke bawah
  Widget _buildMetaRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF2E5959)),
          const SizedBox(width: 10),
          SizedBox(
            width: 75,
            child: Text(
              label,
              style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}