import 'dart:convert';
import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/features/image_analyzer/service/image_service.dart';
import 'package:nusa_app/features/image_analyzer/widgets/expendable_card.dart';
import 'package:nusa_app/routes/router.dart';
import 'package:nusa_app/util/extensions.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:nusa_app/widgets/back_button.dart';
import '../model/image_object.dart';
import 'package:sizer/sizer.dart';

@RoutePage()
class ImageResultPage extends StatefulWidget {
  final File image;
  final ImageObject? imageObject; // Pre-analyzed data
  
  const ImageResultPage({
    super.key, 
    required this.image,
    this.imageObject, // Optional - if not provided, will analyze
  });

  @override
  State<ImageResultPage> createState() => _ImageResultPageState();
}

class _ImageResultPageState extends State<ImageResultPage> {
  late Future<ImageObject?> _budaya;

  @override
  void initState() {
    super.initState();
    
    // Jika imageObject sudah ada (dari ImageConfirmationPage), 
    // langsung gunakan tanpa loading tambahan
    if (widget.imageObject != null) {
      _budaya = Future.value(widget.imageObject);
    } else {
      // Hanya analyze jika belum ada data (fallback)
      _budaya = analyzeAndParse(widget.image);
    }
  }

  Future<ImageObject?> analyzeAndParse(File image) async {
    try {
      final response = await analyzeImage(context, image);
      
      final regex = RegExp(r'```json\n(.*?)\n```', dotAll: true);
      final match = regex.firstMatch(response);

      if (match != null) {
        final jsonStr = match.group(1);
        if (jsonStr != null) {
          final jsonMap = jsonDecode(jsonStr);
          return ImageObject.fromJson(jsonMap);
        }
      }

      // Jika parsing gagal, return null dan pop dengan error
      if (mounted) {
        AutoRouter.of(context).maybePop({'isNotValid': true});
      }
      return null;
    } catch (e) {
      // Jika ada error, pop dengan error
      if (mounted) {
        AutoRouter.of(context).maybePop({'isNotValid': true});
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        body: Stack(children: [
          FutureBuilder<ImageObject?>(
              future: _budaya,
              builder: (context, snapshot) {
                // Jika data sudah ada (dari pre-analysis), langsung tampilkan
                if (widget.imageObject != null && snapshot.hasData) {
                  final budaya = snapshot.data!;
                  return _buildContent(budaya);
                }
                
                // Jika masih loading dan belum ada pre-analyzed data
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: AppColors.primary50),
                        SizedBox(height: 16),
                        Text('Memuat hasil analisis...')
                      ],
                    )
                  );
                }

                // Jika ada error atau data null
                if (snapshot.hasError || snapshot.data == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, size: 48, color: AppColors.danger50),
                        SizedBox(height: 16),
                        Text('Gagal memuat data budaya.'),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Kembali'),
                        )
                      ],
                    )
                  );
                }
                
                final budaya = snapshot.data!;
                return _buildContent(budaya);
              }),
          Positioned(
            bottom: 8.h,
            right: 6.w,
            child: SizedBox(
              width: 15.w,
              height: 15.w,
              child: FloatingActionButton(
                backgroundColor: AppColors.primary50,
                elevation: 4,
                onPressed: () {
                  context.router.push(NusaBotRoute());
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.w),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/icons/nusabot_icon.png',
                    width: 30.w,
                    height: 30.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ]));
  }

  Widget _buildContent(ImageObject budaya) {
    return ListView(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(12)),
          child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Image.file(
                      File(widget.image.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.black.withOpacity(0.5),
                    ),
                  ),
                  Positioned(
                      top: 20,
                      left: 20,
                      child: CustomBackButton(
                        backgroundColor:
                            AppColors.grey60.withOpacity(0.3),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        iconColor: AppColors.grey10,
                      )),
                  Positioned(
                      left: 24,
                      bottom: 24,
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            budaya.namaBudaya,
                            style: context.textTheme.headlineMedium
                                ?.copyWith(color: AppColors.white),
                          ),
                          Row(
                            children: [
                              Icon(IconsaxPlusBold.location,
                                  color: AppColors.success50,
                                  size: 20),
                              SizedBox(width: 4),
                              Text(
                                  "${budaya.asalKota}, ${budaya.asalProvinsi}",
                                  style: context
                                      .textTheme.bodyMedium
                                      ?.copyWith(
                                          color: AppColors.white)),
                            ],
                          )
                        ],
                      ))
                ],
              )),
        ),
        SizedBox(height: 24),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Overview",
                      style: context.textTheme.headlineSmall,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.primary50,
                      ),
                      child: Text(
                        budaya.kategoriObjek,
                        style:
                            context.textTheme.bodyMedium?.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  budaya.deskripsiSingkat,
                  style: context.textTheme.bodyMedium,
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 12),
                ExpandableCard(
                  title: 'History',
                  icon: IconsaxPlusBold.search_favorite,
                  content: budaya.sejarah,
                ),
                SizedBox(
                  height: 12,
                ),
                ExpandableCard(
                  title: 'Cultural Function',
                  icon: IconsaxPlusBold.airdrop,
                  content: budaya.fungsiBudaya,
                ),
                SizedBox(
                  height: 12,
                ),
                ExpandableCard(
                  title: 'Place of Origin',
                  icon: IconsaxPlusBold.map,
                  content: budaya.asalDaerah,
                ),
                SizedBox(
                  height: 12,
                ),
                ExpandableCard(
                  title: 'Symbolic Philosophy',
                  icon: IconsaxPlusBold.status_up,
                  content: budaya.filosofiSimbolik,
                ),
                SizedBox(
                  height: 12,
                ),
                ExpandableCard(
                  title: 'Main Materials',
                  icon: IconsaxPlusBold.route_square,
                  content: budaya.materialUtama,
                ),
                SizedBox(
                  height: 12,
                ),
                ExpandableCard(
                  title: 'Modern Development',
                  icon: IconsaxPlusBold.flash,
                  content: budaya.perkembanganKini,
                ),
                SizedBox(
                  height: 12,
                ),
                ExpandableCard(
                  title: 'Visitor Guide',
                  icon: IconsaxPlusBold.info_circle,
                  content: budaya.panduanPengunjung,
                ),
                SizedBox(
                  height: 24,
                )
              ],
            )),
      ],
    );
  }
}