import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/core/styles.dart';
import 'package:nusa_app/features/image_analyzer/widgets/grid_painter.dart';
import 'package:nusa_app/l10n/l10n.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:nusa_app/routes/router.dart';
import 'package:image_picker/image_picker.dart';

@RoutePage()
class ImageAnalyzerPage extends StatefulWidget {
  const ImageAnalyzerPage({super.key});

  @override
  State<ImageAnalyzerPage> createState() => _ImageAnalyzerPageState();
}

class _ImageAnalyzerPageState extends State<ImageAnalyzerPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  XFile? pickedImage;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  Future<void> _setupCamera() async {
    try {
      // Ambil semua kamera yang tersedia
      final cameras = await availableCameras();

      // Pilih kamera belakang jika ada
      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      // Buat controller dan inisialisasi
      _controller = CameraController(backCamera, ResolutionPreset.high);
      _initializeControllerFuture = _controller.initialize();

      setState(() {}); // Trigger build ulang saat controller sudah siap
    } catch (e) {
      print('Gagal setup kamera: $e');
    }
  }

  Future<void> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      print('Path gambar: ${image.path}');
    } else {
      print('Tidak ada gambar dipilih.');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // agar konten bisa ke bawah nav bar
      body: _initializeControllerFuture == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: CameraPreview(_controller),
                      ),
                      Positioned.fill(
                        child: CustomPaint(
                          painter: GridPainter(),
                        ),
                      ),
                      Positioned.fill(
                          child: Image.asset(
                        'assets/core/scanner_mockup.png',
                        width: 52,
                      )),
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
      floatingActionButton: Container(
        margin: EdgeInsets.symmetric(vertical: 84),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 36,
          children: [
            FloatingActionButton(
              backgroundColor: AppColors.grey60.withOpacity(0.3),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              onPressed: () async {
                AutoRouter.of(context).maybePop();
              },
              child: Icon(
                IconsaxPlusBold.arrow_left_3,
                color: AppColors.grey10,
              ),
            ),
            FloatingActionButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              elevation: 0,
              onPressed: () async {
                try {
                  await _initializeControllerFuture;
                  final image = await _controller.takePicture();
                  print('Foto disimpan di: ${image.path}');
                  AutoRouter.of(context)
                      .push(ImageConfirmationRoute(pickedImage: image));
                } catch (e) {
                  print('Gagal mengambil foto: $e');
                }
              },
              child: const Icon(Icons.camera_alt),
            ),
            FloatingActionButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              elevation: 0,
              onPressed: () async {
                try {
                  final picked =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    setState(() {
                      pickedImage = picked;
                    });
                    AutoRouter.of(context).push(
                        ImageConfirmationRoute(pickedImage: pickedImage!));
                  }
                } catch (e) {
                  print('Gagal mengambil foto: $e');
                }
              },
              child: Icon(IconsaxPlusBold.gallery),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
