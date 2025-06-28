import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/features/image_analyzer/widgets/grid_painter.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:nusa_app/routes/router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

@RoutePage()
class ImageAnalyzerPage extends StatefulWidget {
  const ImageAnalyzerPage({super.key});

  @override
  State<ImageAnalyzerPage> createState() => _ImageAnalyzerPageState();
}

class _ImageAnalyzerPageState extends State<ImageAnalyzerPage> {
  CameraController? _controller; // Ubah dari late ke nullable
  Future<void>? _initializeControllerFuture; // Ubah dari late ke nullable
  File? pickedImage;
  final ImagePicker picker = ImagePicker();
  bool _isInitializing = true; // Tambahkan state untuk loading
  String? _errorMessage; // Tambahkan state untuk error

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  Future<void> _setupCamera() async {
    try {
      setState(() {
        _isInitializing = true;
        _errorMessage = null;
      });

      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        setState(() {
          _errorMessage = 'No cameras available';
          _isInitializing = false;
        });
        return;
      }

      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _controller = CameraController(backCamera, ResolutionPreset.high);
      _initializeControllerFuture = _controller!.initialize();

      await _initializeControllerFuture;

      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    } catch (e) {
      print('Gagal setup kamera: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Gagal mengakses kamera: $e';
          _isInitializing = false;
        });
      }
    }
  }

  Future<void> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        // Ambil direktori sementara
        final tempDir = await getTemporaryDirectory();

        // Ambil ekstensi asli file
        final extension = path.extension(pickedFile.path);

        // Buat path baru untuk menyimpan file
        final fileName =
            'temp_image_${DateTime.now().millisecondsSinceEpoch}$extension';
        final savedPath = path.join(tempDir.path, fileName);

        // Simpan file ke direktori sementara, convert XFile to File
        final savedImage = await File(pickedFile.path).copy(savedPath);

        // Navigasi ke halaman konfirmasi
        if (mounted) {
          AutoRouter.of(context)
              .push(ImageConfirmationRoute(pickedImage: savedImage));
        }
      } catch (e) {
        print('Error saat menyimpan gambar: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memproses gambar: $e')),
          );
        }
      }
    } else {
      print('Tidak ada gambar dipilih.');
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      print('Controller kamera tidak siap');
      return;
    }

    try {
      final image = await _controller!.takePicture();
      final pickedImage = File(image.path);
      print('Foto disimpan di: ${image.path}');

      if (mounted) {
        AutoRouter.of(context)
            .push(ImageConfirmationRoute(pickedImage: pickedImage));
      }
    } catch (e) {
      print('Gagal mengambil foto: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil foto: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _buildBody(),
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
              onPressed: _takePicture,
              child: const Icon(Icons.camera_alt),
            ),
            FloatingActionButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              elevation: 0,
              onPressed: pickImageFromGallery,
              child: Icon(IconsaxPlusBold.gallery),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBody() {
    if (_isInitializing) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Mempersiapkan kamera...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _setupCamera,
              child: Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        Positioned.fill(
          child: CameraPreview(_controller!),
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
          ),
        ),
      ],
    );
  }
}
