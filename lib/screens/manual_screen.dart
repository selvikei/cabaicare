import 'package:flutter/material.dart';
import '../widgets/appbar_widget.dart';
import '../data/manual_data.dart';

class ManualScreen extends StatefulWidget {
  const ManualScreen({super.key});

  @override
  State<ManualScreen> createState() => _ManualScreenState();
}

class _ManualScreenState extends State<ManualScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Logika pencarian fleksibel yang menyisir judul maupun teks konten di dalam array steps
    // Mengambil data dari ManualData.data secara langsung
    final filteredManual = ManualData.data.where((item) {
      final titleLower = item['title'].toString().toLowerCase();
      final searchLower = _searchQuery.toLowerCase();

      bool matchesContent = false;
      for (var step in (item['steps'] as List)) {
        if (step['content'] != null &&
            step['content'].toString().toLowerCase().contains(searchLower)) {
          matchesContent = true;
          break;
        }
      }
      return titleLower.contains(searchLower) || matchesContent;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: "Panduan Manual Aplikasi",
      ),
      body: Column(
        children: [
          // 1. Bilah Pencarian Panduan Fitur
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

          // 2. Konten Akordeon Komponen Daftar Manual (ExpansionTile)
          Expanded(
            child: filteredManual.isEmpty
                ? const Center(
                    child: Text(
                      "Panduan fitur tidak ditemukan.",
                      style: TextStyle(fontFamily: 'Inter', color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            leading: Icon(item['icon'],
                                color: const Color(0xFF2E5959)),
                            title: Text(
                              item['title'],
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E5959),
                                fontSize: 14,
                              ),
                            ),
                            trailing: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Color(0xFF2E5959)),
                            childrenPadding: const EdgeInsets.all(16),
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                    (item['steps'] as List).map<Widget>((step) {
                                  // RENDER TYPE 1: PARAGRAF DESKRIPSI BIASA
                                  if (step['type'] == 'text') {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        step['content'],
                                        style: const TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 13,
                                            color: Colors.black87,
                                            height: 1.5),
                                        textAlign: TextAlign.justify,
                                      ),
                                    );
                                  }

                                  // RENDER TYPE 2: ELEMEN GAMBAR / SCREENSHOT
                                  else if (step['type'] == 'image') {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 14.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.asset(
                                          step['imagePath'],
                                          width: double.infinity,
                                          height: 200,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            // Fallback widget jika file aset gambar belum diletakkan di folder assets
                                            return Container(
                                              width: double.infinity,
                                              height: 150,
                                              color: Colors.grey[300],
                                              child: const Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.image,
                                                      size: 40,
                                                      color: Colors.grey),
                                                  SizedBox(height: 6),
                                                  Text("Ilustrasi Alur Panduan",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey)),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  }

                                  // RENDER TYPE 3: URUTAN DATA BERANGKA (NUMBERING)
                                  else if (step['type'] == 'number') {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 24,
                                            child: Text(
                                              step['number'],
                                              style: const TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF2E5959)),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              step['content'],
                                              style: const TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 13,
                                                  color: Colors.black87,
                                                  height: 1.5),
                                              textAlign: TextAlign.justify,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  // RENDER TYPE 4: POIN BULAT (BULLET POINTS)
                                  else if (step['type'] == 'bullet') {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "•  ",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF2E5959)),
                                          ),
                                          Expanded(
                                            child: Text(
                                              step['content'],
                                              style: const TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 13,
                                                  color: Colors.black87,
                                                  height: 1.5),
                                              textAlign: TextAlign.justify,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
