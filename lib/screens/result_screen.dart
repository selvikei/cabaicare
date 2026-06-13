import 'package:flutter/material.dart';
import 'dart:io';
import '../data/database_helper.dart';
import '../models/history_mode.dart';

class ResultScreen extends StatelessWidget {
  final String imagePath;
  final List<Map<String, dynamic>> detections;

  const ResultScreen({
    super.key,
    required this.imagePath,
    required this.detections,
  });

  // Warna sesuai brand dan jenis hama
  Color _getBoxColor(String label) {
    String cleanLabel = label.trim().toLowerCase();
    if (cleanLabel.contains('daun')) return Colors.purple;
    if (cleanLabel.contains('kebul')) return Colors.red;
    if (cleanLabel.contains('thrips')) return Colors.blue;
    return const Color(0xFF2E5959);
  }

  @override
  Widget build(BuildContext context) {
    double displaySize = MediaQuery.of(context).size.width - 40;

    // 1. Logika Label Dominan
    String topLabel = detections.isNotEmpty
        ? detections[0]['label']
        : "Tidak Terdapat Hama";

    // 2. Logika Hitung Jumlah Objek per Jenis
    int countKutuDaun = detections
        .where((d) => d['label'].toLowerCase().contains('daun'))
        .length;
    int countKutuKebul = detections
        .where((d) => d['label'].toLowerCase().contains('kebul'))
        .length;
    int countThrips = detections
        .where((d) => d['label'].toLowerCase().contains('thrips'))
        .length;

    // 3. Ambil Confidence Tertinggi
    double maxConfidence = detections.isNotEmpty
        ? (double.tryParse(detections[0]['confidence'].toString()) ?? 0.0)
        : 0.0;
    String percentage = "${(maxConfidence).toStringAsFixed(1)}%";

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      appBar: AppBar(
        title: const Text(
          "Hasil Deteksi",
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // --- AREA GAMBAR ---
            Center(
              child: Container(
                width: displaySize,
                height: displaySize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      Image.file(
                        File(imagePath),
                        width: displaySize,
                        height: displaySize,
                        fit: BoxFit.fill,
                      ),
                      ...detections
                          .map(
                            (det) => Positioned(
                              left: det['x'] * displaySize,
                              top: det['y'] * displaySize,
                              child: Container(
                                width: det['w'] * displaySize,
                                height: det['h'] * displaySize,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _getBoxColor(det['label']),
                                    width: 2.5,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // --- KARTU HASIL (SESUAI GAMBAR UI) ---
            // --- KARTU HASIL (MODIFIKASI KONDISIONAL) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F7F0).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color(0xFF2E5959).withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul Status (Misal: Tidak Terdapat Hama / Kutu Daun)
                    Text(
                      topLabel,
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _getBoxColor(topLabel),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 10),

                    // List Statistik Hama (Tetap Ditampilkan)
                    _buildPestStatRow(
                      "Kutu Daun",
                      countKutuDaun,
                      Colors.purple,
                    ),
                    const SizedBox(height: 12),
                    _buildPestStatRow("Kutu Kebul", countKutuKebul, Colors.red),
                    const SizedBox(height: 12),
                    _buildPestStatRow("Thrips", countThrips, Colors.blue),

                    // --- LOGIKA KONDISIONAL UNTUK KEYAKINAN ---
                    // Hanya tampil jika topLabel BUKAN "Tidak Terdapat Hama"
                    if (topLabel != "Tidak Terdapat Hama") ...[
                      const SizedBox(height: 15),
                      const Divider(color: Colors.grey),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Tingkat Keyakinan",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            percentage,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // --- TOMBOL AKSI ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final history = HistoryModel(
                          imagePath: imagePath,
                          detectedClass: topLabel,
                          confidenceScore: detections.isNotEmpty
                              ? detections[0]['confidence'].toString()
                              : "0.0",
                          detectedAt: DateTime.now().toString(),
                          boundingBoxes:
                              detections, // Menyimpan rincian koordinat
                        );
                        await DatabaseHelper.instance.insertHistory(history);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Berhasil disimpan!"),
                              backgroundColor: Color(0xFF2E5959),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E5959),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Simpan",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(
                          color: Color(0xFF2E5959),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Deteksi Lagi",
                        style: TextStyle(
                          color: Color(0xFF2E5959),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // Widget untuk baris statistik objek (Kutu Daun: X objek)
  Widget _buildPestStatRow(String label, int count, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(radius: 6, backgroundColor: color),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2E5959),
              ),
            ),
          ],
        ),
        Text(
          "$count objek",
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
