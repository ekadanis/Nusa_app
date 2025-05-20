import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/features/image_analyzer/widgets/expendable_card.dart';
import 'package:nusa_app/util/extensions.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:nusa_app/widgets/back_button.dart';

@RoutePage()
class ImageResultPage extends StatefulWidget {
  final XFile image;
  const ImageResultPage({super.key, required this.image});

  @override
  State<ImageResultPage> createState() => _ImageResultPageState();
}

class _ImageResultPageState extends State<ImageResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: ListView(
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
                          backgroundColor: AppColors.grey60.withOpacity(0.3),
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
                    'Overview',
                    style: context.textTheme.headlineSmall,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Tari Reog adalah salah satu tarian tradisional yang berasal dari Ponorogo, Jawa Timur. Tarian ini sangat terkenal karena pertunjukannya yang megah dan penuh kekuatan. Ciri khas utama dari Tari Reog adalah topeng besar yang disebut Singa Barong, yaitu kepala singa besar dengan hiasan bulu merak yang menjulang tinggi. Topeng ini bisa memiliki berat hingga 50 kilogram dan biasanya dipanggul oleh seorang penari menggunakan gigi atau rahangnya sebagai simbol kekuatan dan kesaktian.',
                    style: context.textTheme.bodyMedium,
                  ),
                  SizedBox(height: 12),
                  ExpandableCard(
                      title: 'History', icon: IconsaxPlusBold.search_favorite),
                  SizedBox(
                    height: 12,
                  ),
                  ExpandableCard(
                      title: 'Cultural Function',
                      icon: IconsaxPlusBold.airdrop),
                  SizedBox(
                    height: 12,
                  ),
                  ExpandableCard(
                      title: 'Place of Origin', icon: IconsaxPlusBold.map),
                  SizedBox(
                    height: 12,
                  ),
                  ExpandableCard(
                      title: 'Symbolic Philosophy',
                      icon: IconsaxPlusBold.status_up),
                  SizedBox(
                    height: 12,
                  ),
                  ExpandableCard(
                      title: 'Main Materials',
                      icon: IconsaxPlusBold.route_square),
                  SizedBox(
                    height: 12,
                  ),
                  ExpandableCard(
                      title: 'Modern Development', icon: IconsaxPlusBold.flash),
                  SizedBox(
                    height: 24,
                  )
                ],
              )),
        ],
      ),
    );
  }
}
