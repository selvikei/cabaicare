import 'package:flutter/material.dart';
import '../widgets/appbar_widget.dart';

class ManualScreen extends StatefulWidget {
  const ManualScreen({super.key});

  @override
  State<ManualScreen> createState() => _ManualScreenState();
}

class _ManualScreenState extends State<ManualScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  // Data struktur untuk menampung isi konten panduan manual
  final List<Map<String, dynamic>> _manualData = [
    {
      "id": 1,
      "title": "Deteksi di Sini (Jepret/Upload Gambar)",
      "icon": Icons.camera_alt_rounded,
      "hasImage": true, // Menandakan fitur ini butuh ilustrasi gambar
      "content": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
    },
    {
      "id": 2,
      "title": "Fitur Deteksi Real-Time",
      "icon": Icons.videocam_rounded,
      "hasImage": false,
      "content": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pemicu aliran kamera langsung akan menganalisis frame daun cabai secara instan menggunakan model YOLOv8n untuk mendeteksi pergerakan hama tanpa jeda jepretan."
    },
    {
      "id": 3,
      "title": "Fitur Informasi Cabai",
      "icon": Icons.info_rounded,
      "hasImage": false,
      "content": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Menyediakan edukasi dasar seputar varietas tanaman cabai, teknik penanaman yang baik, serta tips perawatan agrikultur harian."
    },
    {
      "id": 4,
      "title": "Fitur Informasi Hama Cabai",
      "icon": Icons.bug_report_rounded,
      "hasImage": false,
      "content": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Berisi ensiklopedia mini mengenai jenis-jenis hama cabai (seperti kutu daun, ulat, thrips) beserta gejala klinis dan metode penanggulangannya."
    },
    {
      "id": 5,
      "title": "Fitur Riwayat",
      "icon": Icons.history_rounded,
      "hasImage": false,
      "content": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Menyimpan berkas digital hasil scan hama sebelumnya ke dalam database lokal Sqflite lengkap dengan waktu, gambar, dan tingkat akurasi presisi."
    },
    {
      "id": 6,
      "title": "Fitur Rating (Coming Soon)",
      "icon": Icons.star_rate_rounded,
      "hasImage": false,
      "content": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fitur masa depan yang memungkinkan para petani memberikan penilaian umpan balik terhadap akurasi model deteksi guna pengembangan sistem berkala."
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Logika pemfilteran menu berdasarkan kata kunci pencarian
    final filteredManual = _manualData.where((item) {
      final titleLower = item['title'].toString().toLowerCase();
      final contentLower = item['content'].toString().toLowerCase();
      final searchLower = _searchQuery.toLowerCase();
      return titleLower.contains(searchLower) || contentLower.contains(searchLower);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: "Panduan Manual Aplikasi",
      ),
      body: Column(
        children: [
          // ========================================================
          // KANVAS PENCARIAN (SEARCH BAR KEYWORD)
          // ========================================================
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Cari panduan fitur...",
                prefixIcon: const Icon(Icons.search, color: Color(0xFF2E5959)),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = "";
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFFE9EFEF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),

          // ========================================================
          // LIST EXPANSION TILE (BUKA TUTUP MANUAL)
          // ========================================================
          Expanded(
            child: filteredManual.isEmpty
                ? const Center(
                    child: Text(
                      "Panduan fitur tidak ditemukan.",
                      style: TextStyle(fontFamily: 'Inter', color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filteredManual.length,
                    itemBuilder: (context, index) {
                      final item = filteredManual[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F7F7),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE0EBEB)),
                        ),
                        child: Theme(
                          // Menghilangkan garis pembatas bawaan expansion tile saat terbuka
                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            leading: Icon(item['icon'], color: const Color(0xFF2E5959)),
                            title: Text(
                              item['title'],
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E5959),
                                fontSize: 14,
                              ),
                            ),
                            // Desain tanda panah otomatis berubah arah jika dibuka/tutup
                            trailing: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF2E5959)),
                            childrenPadding: const EdgeInsets.all(16),
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Kondisional jika item ID 1 membutuhkan render gambar rata kiri
                                  if (item['hasImage'] == true) ...[
                                    Container(
                                      width: 120,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.image, size: 40, color: Colors.grey), // Ganti Image.asset nanti
                                    ),
                                    const SizedBox(height: 12),
                                  ],
                                  // Teks Deskripsi Lorem Ipsum di bawah gambar
                                  Text(
                                    item['content'],
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 13,
                                      color: Colors.black87,
                                      height: 1.5,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // ========================================================
          // FORMAL ACADEMIC COPYRIGHT BOTTOM SECTION
          // ========================================================
          // Container(
          //   width: double.infinity,
          //   padding: const EdgeInsets.symmetric(vertical: 16),
          //   color: const Color(0xFF2E5959),
          //   child: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       const Text(
          //         "© 2026 Selvi - Politeknik Elektronika Negeri Surabaya",
          //         style: TextStyle(
          //           fontFamily: 'Inter',
          //           color: Colors.white70,
          //           fontSize: 11,
          //           fontWeight: FontWeight.w500,
          //         ),
          //       ),
          //       const SizedBox(height: 2),
          //       Text(
          //         "CabaiCare Team • PENS",
          //         style: TextStyle(
          //           fontFamily: 'Inter',
          //           color: Colors.white.withValues(alpha: 0.4),
          //           fontSize: 9,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}