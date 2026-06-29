import 'dart:ui';
import 'package:flutter/material.dart';
import '../widgets/header_section.dart';
import '../widgets/detection_banner.dart';
import '../widgets/chili_card.dart';
import '../widgets/pest_grid_section.dart';
import '../widgets/history_item_card.dart';
import '../screens/detector_screen.dart';
import '../screens/history_list_screen.dart';
import '../data/database_helper.dart';
import '../models/history_mode.dart';
import '../screens/camera_inference_screen.dart';
import '../widgets/appbar_widget.dart';
import '../screens/manual_screen.dart';
import '../screens/rating_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    // 1. DAFTAR MULTI-HALAMAN UNTUK NAVBAR
    final List<Widget> pages = [
      _buildDashboard(),          // Index 0: Dashboard Utama (Home)
      const HistoryListScreen(),  // Index 1: Semua Riwayat
      const SizedBox(),           // Index 2: Placeholder Real Time (Ditrigger manual via onTap)
      const ManualScreen(),       // Index 3: Buku Panduan Manual
      const RatingScreen(),       // Index 4: Rating
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E5959), // Warna solid hijau gelap CabaiCare
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Stack(
        children: [
          // Render Halaman sesuai indeks yang aktif saat ini
          SafeArea(
            top: false,
            bottom: false,
            child: pages[_currentIndex],
          ),

          // 2. STRUKTUR FLOATING SOLID FLOATING NAVBAR (MENGAMBANG & MELENGKUNG)
          Positioned(
            left: 16,
            right: 16,
            bottom: 20, // Mengambang di atas batas bawah layar
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 65,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E5959), // Warna solid hijau gelap CabaiCare
                    borderRadius: BorderRadius.circular(30), // Membuat lengkungan penuh di ujung
                    boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2E5959).withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavbarItem(Icons.home_rounded, "Home", 0),
                    _buildNavbarItem(Icons.history_rounded, "Riwayat", 1),
                    const SizedBox(width: 60), // Spasi untuk tombol kamera tengah
                    _buildNavbarItem(Icons.menu_book_rounded, "Manual", 3),
                    _buildNavbarItem(Icons.star_rounded, "Rating", 4),
                  ],
                ),
              ),
              Positioned(
                  top: -25, // Angka minus ini yang membuatnya naik memotong navbar
                  child: _buildSpecialCameraItem(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget Item Navbar Standar
  Widget _buildNavbarItem(IconData icon, String label, int index) {
    bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        color: Colors.transparent, // Memperluas area klik
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Tombol Kamera Tengah Khusus (Navigasi langsung Fullscreen ke Real-Time YOLO)
  Widget _buildSpecialCameraItem() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CameraInferenceScreen()),
        ).then((_) => _refresh());
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Bulatan Tombol Besar yang Mengambang
          Container(
            width: 60, // Ukuran bulatan diperbesar agar menonjol
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white, 
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4), // Efek shadow biar kelihatan makin mengambang
                ),
              ],
            ),
            child: const Icon(
              Icons.videocam_rounded,
              color: Color(0xFF2E5959),
              size: 32, // Ukuran ikon diperbesar
            ),
          ),
          const SizedBox(height: 4),
          // Label Nama di Bawah Tombol
          const Text(
            "Real-Time",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Menyesuaikan warna teks navbar lainnya
            ),
          ),
        ],
      ),
    );
  }
  
  // --- WIDGET DASHBOARD UTAMA (CONTENT) ---
  Widget _buildDashboard() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeaderSection(), 
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
                const ChiliCard(), 
                const SizedBox(height: 25),
                const PestGridSection(), 
                const SizedBox(height: 30),
                _buildHistoryHeader(),
                const SizedBox(height: 15),
                _buildHistoryPreview(), 
                const SizedBox(height: 110), // Spasi krusial agar konten paling bawah tidak tertutup oleh Floating Navbar
              ],
            ),
          ),
        ],
      ),
    );
  }

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
          onTap: () {
            setState(() {
              _currentIndex = 1; // Pindah langsung ke index tab Riwayat di Navbar
            });
          },
          child: Container(
            height: 36, width: 36,
            decoration: const BoxDecoration(color: Color(0xFFE9EFEF), shape: BoxShape.circle),
            child: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF2E5959)),
          ),
        ),
      ],
    );
  }

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

  // Placeholder Widget untuk halaman kosong (Rating)
  Widget _buildPlaceholderHalaman(String pesan) {
    return Center(
      child: Text(
        pesan,
        textAlign: TextAlign.center,
        style: const TextStyle(fontFamily: 'Inter', fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
      ),
    );
  }
}