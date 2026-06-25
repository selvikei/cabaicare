// Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

import 'package:flutter/material.dart';
import '../controllers/camera_inference_controller.dart';
import '../widgets/camera_inference_content.dart';
import '../widgets/camera_inference_overlay.dart';
import '../widgets/camera_logo_overlay.dart';
import '../widgets/camera_controls.dart';
import '../widgets/threshold_slider.dart';
import '../widgets/appbar_widget.dart';


class CameraInferenceScreen extends StatefulWidget {
  const CameraInferenceScreen({super.key});

  @override
  State<CameraInferenceScreen> createState() => _CameraInferenceScreenState();
}

class _CameraInferenceScreenState extends State<CameraInferenceScreen> {
  late final CameraInferenceController _controller;
  int _rebuildKey = 0;

  @override
  void initState() {
    super.initState();
    _controller = CameraInferenceController();
    _controller.initialize().catchError((error) {
      if (mounted) {
        _showError('Model Loading Error', error.toString());
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route?.isCurrent == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _rebuildKey++;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: Colors.black, // Memastikan kontras video kamera bagus
      appBar: const CustomAppBar(
        title: "Real-Time Deteksi Hama",
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              // --------------------------------------------------------
              // Lapisan 1 & 2: Kamera dan Bounding Box di dalam satu basis ukuran
              // --------------------------------------------------------
              LayoutBuilder(
                builder: (context, constraints) {
                  // Mengambil ukuran presisi area konten yang tersedia
                  final maxWidth = constraints.maxWidth;
                  final maxHeight = constraints.maxHeight;

                  return SizedBox(
                    width: maxWidth,
                    height: maxHeight,
                    child: Stack(
                      children: [
                        // Feed Kamera dasar dari YOLOView
                        CameraInferenceContent(
                          key: ValueKey('camera_content_$_rebuildKey'),
                          controller: _controller,
                          rebuildKey: _rebuildKey,
                        ),

                        // Bounding Box Kustom Manual
                        ..._controller.currentResults.map((result) {
                          // ✅ Gunakan normalizedBox (0.0–1.0) agar presisi
                          // di semua resolusi kamera dan ukuran layar
                          final norm = result.normalizedBox;

                          // Inisiasi warna manual berdasarkan nama kelas target
                          Color boxColor;
                          switch (result.className.toLowerCase()) {
                            case 'kutu daun':
                            case 'aphids':
                              boxColor = Colors.purple; // Kutu Daun -> Ungu
                              break;
                            case 'kutu kebul':
                            case 'bemisia tabaci':
                              boxColor = Colors.red; // Kutu Kebul -> Merah
                              break;
                            case 'thrips':
                            case 'thrips parvispinus':
                              boxColor = Colors.blue; // Thrips -> Biru
                              break;
                            default:
                              boxColor =
                                  const Color(0xFFFFD700); // Default Kuning
                          }

                          // UKURAN KOTAK TETAP (ubah nilai ini sesuai selera)
                          const double fixedSize = 22.0;

                          // Tengahkan kotak terhadap pusat objek yang terdeteksi
                          final double centerX =
                              (norm.left + norm.width / 2) * maxWidth;
                          final double centerY =
                              (norm.top + norm.height / 2) * maxHeight;

                          final double left = centerX - fixedSize / 2;
                          final double top = centerY - fixedSize / 2;
                          const double width = fixedSize;
                          const double height = fixedSize;

                          return Positioned(
                            left: left,
                            top: top,
                            width: width,
                            height: height,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                // Bingkai kotak kustom hama
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: boxColor,
                                      width: 3.0,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                    color: boxColor.withOpacity(0.12),
                                  ),
                                ),

                                // Label Teks Nama Hama + Persentase Confidence
                                Positioned(
                                  top:
                                      -20, // Mengambang pas di atas garis kotak kustom
                                  left: -3,
                                  child: Container(
                                    // 💡 PERBAIKAN: Menghapus properti 'color:' luar yang bikin crash,
                                    // sekarang murni dibungkus di dalam BoxDecoration.
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: boxColor,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(3),
                                        topRight: Radius.circular(3),
                                      ),
                                    ),
                                    child: Text(
                                      "${result.className.toUpperCase()} ${(result.confidence * 100).toStringAsFixed(0)}%",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                },
              ),

              // --------------------------------------------------------
              // Lapisan UI Kontrol & Metrik (Tetap berada di Stack teratas layar)
              // --------------------------------------------------------
              CameraInferenceOverlay(
                controller: _controller,
                isLandscape: isLandscape,
              ),

              CameraControls(
                currentZoomLevel: _controller.currentZoomLevel,
                isFrontCamera: _controller.isFrontCamera,
                activeSlider: _controller.activeSlider,
                onZoomChanged: _controller.setZoomLevel,
                onSliderToggled: _controller.toggleSlider,
                onCameraFlipped: _controller.flipCamera,
                isLandscape: isLandscape,
              ),

              ThresholdSlider(
                activeSlider: _controller.activeSlider,
                confidenceThreshold: _controller.confidenceThreshold,
                iouThreshold: _controller.iouThreshold,
                numItemsThreshold: _controller.numItemsThreshold,
                onValueChanged: _controller.updateSliderValue,
                isLandscape: isLandscape,
              ),
            ],
          );
        },
      ),
    );
  }

  void _showError(String title, String message) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
}
