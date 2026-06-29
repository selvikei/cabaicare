import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../widgets/appbar_widget.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  // Daftar 5 Fitur Utama Aplikasi CabaiCare
  final List<String> _features = [
    "Deteksi Gambar (Jepret/Upload)",
    "Deteksi Real-Time YOLO",
    "Fitur Informasi Cabai",
    "Fitur Informasi Hama",
    "Buku Panduan Manual"
  ];

  // State lokal untuk menampung nilai bintang dan controller teks
  final Map<String, double> _featureRatings = {};
  final Map<String, TextEditingController> _controllers = {};
  double _totalAverage = 0.0;

  @override
  void initState() {
    super.initState();
    // Set nilai default (5 bintang) dan inisialisasi controller teks untuk tiap fitur
    for (var feature in _features) {
      _featureRatings[feature] = 5.0;
      _controllers[feature] = TextEditingController();
    }
    _loadSavedRatings();
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // Mengambil data yang tersimpan dari database lokal
  void _loadSavedRatings() async {
    try {
      final savedData = await DatabaseHelper.instance.getSavedStars();
      setState(() {
        savedData.forEach((key, value) {
          if (_featureRatings.containsKey(key)) {
            _featureRatings[key] = value;
          }
        });
        _calculateAverage();
      });
    } catch (e) {
      debugPrint("Gagal memuat rating dari database: $e");
    }
  }

  // Menghitung rata-rata nilai seluruh fitur secara linear
  void _calculateAverage() {
    double total = 0.0;
    _featureRatings.forEach((key, value) {
      total += value;
    });
    _totalAverage = total / _features.length;
  }

  // Menyimpan rating secara instan per item fitur
  void _saveRatingItem(String featureName) async {
    final stars = _featureRatings[featureName] ?? 5.0;
    final comment = _controllers[featureName]?.text ?? ""; // Komentar bersifat opsional

    await DatabaseHelper.instance.saveSingleRating(featureName, stars, comment);
    
    setState(() {
      _calculateAverage();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Rating untuk '$featureName' berhasil diperbarui!"),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Penilaian Aplikasi"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ========================================================
            // CARD BANNER INDIKATOR RATA-RATA TOTAL USER
            // ========================================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE9EFEF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Rata-rata Penilaian Anda",
                        style: TextStyle(
                          fontFamily: 'Inter', 
                          fontWeight: FontWeight.bold, 
                          fontSize: 13, 
                          color: Color(0xFF2E5959),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _totalAverage.toStringAsFixed(1),
                        style: const TextStyle(
                          fontFamily: 'PlusJakartaSans', 
                          fontSize: 40, 
                          fontWeight: FontWeight.bold, 
                          color: Color(0xFF2E5959),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < _totalAverage.round() ? Icons.star_rounded : Icons.star_border_rounded,
                        color: const Color(0xFFFFD700), // Warna Kuning Gold khas Bintang
                        size: 30,
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              "Berikan Nilai pada Tiap Fitur:",
              style: TextStyle(
                fontFamily: 'Inter', 
                fontWeight: FontWeight.bold, 
                fontSize: 15, 
                color: Color(0xFF2E5959),
              ),
            ),
            const SizedBox(height: 12),

            // ========================================================
            // LIST INPUT DAFTAR FITUR BERJEJER 
            // ========================================================
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _features.length,
              itemBuilder: (context, index) {
                final feature = _features[index];
                final currentStars = _featureRatings[feature] ?? 5.0;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F7F7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE0EBEB)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama Fitur Utama
                      Text(
                        feature,
                        style: const TextStyle(
                          fontFamily: 'Inter', 
                          fontWeight: FontWeight.bold, 
                          fontSize: 14, 
                          color: Color(0xFF2E5959),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Baris Interaksi Bintang Emas (1-5)
                      Row(
                        children: List.generate(5, (starIndex) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _featureRatings[feature] = starIndex + 1.0;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 6.0),
                              child: Icon(
                                starIndex < currentStars ? Icons.star_rounded : Icons.star_border_rounded,
                                color: const Color(0xFFFFD700),
                                size: 28,
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 8),

                      // Kolom Komentar Opsional & Tombol Simpan Sebaris
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 38,
                              child: TextField(
                                controller: _controllers[feature],
                                style: const TextStyle(fontSize: 12),
                                decoration: InputDecoration(
                                  hintText: "Catatan opsional...",
                                  fillColor: Colors.white,
                                  filled: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: const BorderSide(color: Color(0xFFE0EBEB)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: const BorderSide(color: Color(0xFFE0EBEB)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            height: 38,
                            child: ElevatedButton(
                              onPressed: () => _saveRatingItem(feature),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E5959),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              ),
                              child: const Icon(Icons.save_rounded, size: 18),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 100), // Spasi aman agar tidak tertutup Navbar melengkung
          ],
        ),
      ),
    );
  }
}