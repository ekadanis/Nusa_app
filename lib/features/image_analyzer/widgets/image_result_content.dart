import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:sizer/sizer.dart';
import '../model/image_object.dart';
import 'image_result_expandable_card.dart';

class ImageResultContent extends StatelessWidget {
  final ImageObject imageObject;

  const ImageResultContent({
    Key? key,
    required this.imageObject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ImageResultExpandableCard(
          title: 'History',
          icon: IconsaxPlusBold.search_favorite,
          content: imageObject.sejarah,
        ),
        SizedBox(height: 1.5.h),

        ImageResultExpandableCard(
          title: 'Cultural Function',
          icon: IconsaxPlusBold.airdrop,
          content: imageObject.fungsiBudaya,
        ),
        SizedBox(height: 1.5.h),

        ImageResultExpandableCard(
          title: 'Place of Origin',
          icon: IconsaxPlusBold.map,
          content: imageObject.asalDaerah,
        ),
        SizedBox(height: 1.5.h),

        ImageResultExpandableCard(
          title: 'Symbolic Philosophy',
          icon: IconsaxPlusBold.status_up,
          content: imageObject.filosofiSimbolik,
        ),
        SizedBox(height: 1.5.h),

        ImageResultExpandableCard(
          title: 'Main Materials',
          icon: IconsaxPlusBold.route_square,
          content: imageObject.materialUtama,
        ),
        SizedBox(height: 1.5.h),

        ImageResultExpandableCard(
          title: 'Modern Development',
          icon: IconsaxPlusBold.flash,
          content: imageObject.perkembanganKini,
        ),
      ],
    );
  }
}
