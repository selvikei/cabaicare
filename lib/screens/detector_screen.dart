import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import '../main.dart'; 
import 'result_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class DetectorScreen extends StatefulWidget {
  const DetectorScreen({super.key});

  @override
  State<DetectorScreen> createState() => _DetectorScreenState();
}

class _DetectorScreenState extends State<DetectorScreen> {
  CameraController? controller;
  int selectedCameraIndex = 0; 
  bool _isProcessing = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (cameras.isNotEmpty) {
      initCamera(selectedCameraIndex);
    }
  }

  Future<void> initCamera(int index) async {
    controller = CameraController(
      cameras[index],
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await controller!.initialize();
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      debugPrint("Gagal menyalakan kamera: $e");
    }
  }

  // Fungsi Crop Gambar (Hanya mengambil bagian di dalam kotak viewfinder)
  Future<String> _processAndCropImage(String path) async {
    final bytes = await File(path).readAsBytes();
    img.Image? originalImage = img.decodeImage(bytes);

    if (originalImage != null) {
      // Karena kamera kita Full Screen, kita ambil bagian tengah berbentuk persegi
      int size = originalImage.width < originalImage.height 
          ? originalImage.width 
          : originalImage.height;

      int x = (originalImage.width - size) ~/ 2;
      int y = (originalImage.height - size) ~/ 2;

      img.Image croppedImage = img.copyCrop(
        originalImage,
        x: x,
        y: y,
        width: size,
        height: size,
      );

      final croppedFile = File(path)..writeAsBytesSync(img.encodeJpg(croppedImage));
      return croppedFile.path;
    }
    return path;
  }

  Future<void> takePicture() async {
    if (controller == null || !controller!.value.isInitialized || _isProcessing) return;
    try {
      setState(() => _isProcessing = true);
      final XFile image = await controller!.takePicture();
      
      // Potong gambar sesuai kotak yang dilihat user
      String processedPath = await _processAndCropImage(image.path);
      final results = await tfliteService.predict(processedPath);

      if (!mounted) return;
      setState(() => _isProcessing = false);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(imagePath: processedPath, detections: results),
        ),
      );
    } catch (e) {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Scaffold(backgroundColor: Colors.black, body: Center(child: CircularProgressIndicator()));
    }

    final size = MediaQuery.of(context).size;
    final double scanArea = size.width * 0.8; // Ukuran kotak tengah (80% lebar layar)

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Tampilan Kamera Full Screen (Background)
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: controller!.value.previewSize!.height,
                height: controller!.value.previewSize!.width,
                child: CameraPreview(controller!),
              ),
            ),
          ),

          // 2. Overlay Gelap dengan Lubang Tengah (Viewfinder)
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.6), // Kegelapan di luar kotak
                BlendMode.srcOut,
              ),
              child: Stack(
                children: [
                  Container(color: Colors.black), // Background dasar overlay
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: scanArea,
                      height: scanArea,
                      decoration: BoxDecoration(
                        color: Colors.red, // Warna ini akan jadi "lubang" (srcOut)
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Garis Frame Putih di sekeliling lubang
          Align(
            alignment: Alignment.center,
            child: Container(
              width: scanArea,
              height: scanArea,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          // 4. Tombol-tombol UI
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                const Spacer(),
                _buildBottomControls(),
                const SizedBox(height: 20),
              ],
            ),
          ),

          if (_isProcessing) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Text("Bidik Hama", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.photo_library, color: Colors.white, size: 30),
          onPressed: () {}, // Tambahkan pick gallery kamu di sini
        ),
        GestureDetector(
          onTap: takePicture,
          child: Container(
            height: 80, width: 80,
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4)),
            child: Container(margin: const EdgeInsets.all(5), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.flip_camera_android, color: Colors.white, size: 30),
          onPressed: () {
            selectedCameraIndex = selectedCameraIndex == 0 ? 1 : 0;
            initCamera(selectedCameraIndex);
          },
        ),
      ],
    );
  }

  Widget _buildLoadingOverlay() {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          color: Colors.black45,
          child: const Center(child: CircularProgressIndicator(color: Colors.white)),
        ),
      ),
    );
  }
}