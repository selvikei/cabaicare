import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cabai_care/widgets/header_section.dart';
import 'package:cabai_care/widgets/detection_banner.dart';
import 'package:cabai_care/widgets/chili_card.dart';
import 'package:cabai_care/widgets/pest_grid_section.dart';
import 'package:cabai_care/widgets/history_item_card.dart';
import 'package:cabai_care/screens/detector_screen.dart';
import 'package:cabai_care/screens/history_list_screen.dart';
import 'package:cabai_care/data/database_helper.dart';
import 'package:cabai_care/models/history_mode.dart';
import 'package:cabai_care/screens/camera_inference_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // Fungsi untuk menyegarkan data saat kembali ke halaman ini
  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    // List halaman untuk navigasi
    final List<Widget> pages = [
      _buildDashboard(),     // Index 0: Dashboard Utama
      const SizedBox(),      // Index 1: Placeholder untuk Kamera (Tengah)
      const HistoryListScreen(), // Index 2: Halaman Semua Riwayat
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      //extendBody: true, // Agar konten terlihat di balik navbar glass
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: _buildDashboard(),
          ),

          Positioned(
            right: 16, // Jarak dari tepi kanan layar
            bottom: 50, // Jarak dari tepi bawah layar
            child: _buildRealTimeButton(context),
          ),
        ],
      ),
      
    );
  }

  Widget _buildRealTimeButton(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CameraInferenceScreen()),
      ).then((_) => _refresh());
    },
    child: Container(
      // Padding horizontal agar teks dan icon punya ruang
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2E5959),
        // Gunakan StadiumBorder (lonjong) karena ada teks
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E5959).withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Agar ukuran container pas dengan isi
        children: [
          const Icon(
            Icons.videocam_rounded,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 8), // Jarak antara icon dan teks
          const Text(
            "Real Time",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    ),
  );
}

  // --- WIDGET DASHBOARD UTAMA (CONTENT) ---
  Widget _buildDashboard() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeaderSection(), // Full Width
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DetectorScreen()),
                    ).then((_) => _refresh());
                  },
                  child: const DetectionBanner(),
                ),
                const SizedBox(height: 25),
                const ChiliCard(), // Edukasi Cabai
                const SizedBox(height: 25),
                const PestGridSection(), // Info Hama
                const SizedBox(height: 30),
                _buildHistoryHeader(),
                const SizedBox(height: 15),
                _buildHistoryPreview(), // Ambil 3 data terbaru
                // const SizedBox(height: 120), // Spasi agar tidak tertutup Navbar
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Header Riwayat dengan tombol panah (Bullet)
  Widget _buildHistoryHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 36,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF2E5959),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            "Riwayat Deteksi",
            style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HistoryListScreen(),
            ),
          ),
          child: Container(
            height: 36, width: 36,
            decoration: const BoxDecoration(color: Color(0xFFE9EFEF), shape: BoxShape.circle),
            child: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF2E5959)),
          ),
        ),
      ],
    );
  }

  // Preview 3 riwayat terbaru
  Widget _buildHistoryPreview() {
    return FutureBuilder<List<HistoryModel>>(
      future: DatabaseHelper.instance.getAllHistory(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Belum ada riwayat", style: TextStyle(fontFamily: 'Inter', fontSize: 12)));
        }
        final previewList = snapshot.data!.take(3).toList();
        return Column(children: previewList.map((item) => HistoryItemCard(history: item)).toList());
      },
    );
  }
}