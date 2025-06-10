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

@RoutePage()
class ImageResultPage extends StatefulWidget {
  final File image;
  const ImageResultPage({super.key, required this.image});

  @override
  State<ImageResultPage> createState() => _ImageResultPageState();
}

class _ImageResultPageState extends State<ImageResultPage> {
  late Future<ImageObject?> _budaya;

  @override
  void initState() {
    super.initState();
    _budaya = analyzeAndParse(widget.image);
  }

  Future<ImageObject?> analyzeAndParse(File image) async {
    final response;
    try {
      response = await analyzeImage(context, image);
    } catch (e) {
      if (mounted) {
        AutoRouter.of(context).maybePop({'isNotValid': true});
      }
      return null;
    }
    final regex = RegExp(r'```json\n(.*?)\n```', dotAll: true);
    final match = regex.firstMatch(response);

    if (match != null) {
      final jsonStr = match.group(1);
      if (jsonStr != null) {
        final jsonMap = jsonDecode(jsonStr);
        return ImageObject.fromJson(jsonMap);
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: FutureBuilder<ImageObject?>(
          future: _budaya,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError || snapshot.data == null) {
              return Center(child: Text('Gagal memuat data budaya.'));
            }
            final budaya = snapshot.data!;
            return ListView(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(12)),
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
                        Text(
                          budaya.namaBudaya,
                          style: context.textTheme.headlineSmall,
                        ),
                        SizedBox(height: 12),
                        Text(
                          budaya.deskripsiSingkat,
                          style: context.textTheme.bodyMedium,
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
                          height: 24,
                        )
                      ],
                    )),
              ],
            );
          }),
    );
  }
}
