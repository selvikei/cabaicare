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
        title: "Real-Time Pests Detection",
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

                          // Mapping nama hama: keyword → {warna, nama tampilan}
                          // Menggunakan contains() agar fleksibel terhadap
                          // berbagai format className dari YOLO plugin
                          const pestMap = {
                            'kutu daun':  {'color': 'purple', 'display': 'Aphids (Kutu Daun)'},
                            'aphids':     {'color': 'purple', 'display': 'Aphids (Kutu Daun)'},
                            'kutu kebul': {'color': 'red',    'display': 'Whitefly (Kutu Kebul)'},
                            'bemisia':    {'color': 'red',    'display': 'Whitefly (Kutu Kebul)'},
                            'whitefle':   {'color': 'red',    'display': 'Whitefly (Kutu Kebul)'},
                            'whitefly':   {'color': 'red',    'display': 'Whitefly (Kutu Kebul)'},
                            'thrips':     {'color': 'blue',   'display': 'Thrips'},
                          };

                          const colorLookup = {
                            'purple': Colors.purple,
                            'red':    Colors.red,
                            'blue':   Colors.blue,
                          };

                          final classNameLower = result.className.toLowerCase();
                          String displayName = result.className; // fallback
                          Color boxColor = const Color(0xFFFFD700); // default kuning

                          for (final entry in pestMap.entries) {
                            if (classNameLower.contains(entry.key)) {
                              displayName = entry.value['display']!;
                              boxColor = colorLookup[entry.value['color']]!;
                              break;
                            }
                          }

                          // UKURAN KOTAK DINAMIS: menyesuaikan ukuran objek
                          // dari model YOLO, dengan padding agar sedikit lebih besar
                          const double paddingMultiplier = 1.5; // 20% lebih besar dari objek
                          const double minBoxSize = 20.0; // Ukuran minimum agar tetap terlihat

                          // Hitung ukuran berdasarkan normalizedBox dari YOLO
                          final double rawWidth = norm.width * maxWidth * paddingMultiplier;
                          final double rawHeight = norm.height * maxHeight * paddingMultiplier;

                          // Pastikan ukuran minimal agar objek sangat kecil tetap terlihat
                          final double width = rawWidth < minBoxSize ? minBoxSize : rawWidth;
                          final double height = rawHeight < minBoxSize ? minBoxSize : rawHeight;

                          // Tengahkan kotak terhadap pusat objek yang terdeteksi
                          final double centerX =
                              (norm.left + norm.width / 2) * maxWidth;
                          final double centerY =
                              (norm.top + norm.height / 2) * maxHeight;

                          final double left = centerX - width / 2;
                          final double top = centerY - height / 2;

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
                                      "${displayName.toUpperCase()} ${(result.confidence * 100).toStringAsFixed(0)}%",
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
