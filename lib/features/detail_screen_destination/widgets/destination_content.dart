import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:sizer/sizer.dart';
import 'destination_expandable_card.dart';

class DestinationContent extends StatelessWidget {
  final Map<String, String>? generatedContent;

  const DestinationContent({
    Key? key,
    required this.generatedContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DestinationExpandableCard(
          title: 'History',
          icon: IconsaxPlusBold.search_favorite,
          content: generatedContent?['history'] ??
              'Loading historical information...',
        ),
        SizedBox(height: 1.5.h),

        DestinationExpandableCard(
          title: 'Cultural Function',
          icon: IconsaxPlusBold.airdrop,
          content: generatedContent?['cultural_significance'] ??
              'Loading cultural information...',
        ),
        SizedBox(height: 1.5.h),

        DestinationExpandableCard(
          title: 'Place of Origin',
          icon: IconsaxPlusBold.map,
          content: generatedContent?['architecture'] ??
              'Loading architectural information...',
        ),
        SizedBox(height: 1.5.h),

        DestinationExpandableCard(
          title: 'Symbolic Philosophy',
          icon: IconsaxPlusBold.status_up,
          content: generatedContent?['visitor_info'] ??
              'Loading visitor information...',
        ),
        SizedBox(height: 1.5.h),

        DestinationExpandableCard(
          title: 'Main Materials',
          icon: IconsaxPlusBold.route_square,
          content: generatedContent?['conservation'] ??
              'Loading conservation information...',
        ),
        SizedBox(height: 1.5.h),

        DestinationExpandableCard(
          title: 'Modern Development',
          icon: IconsaxPlusBold.flash,
          content: generatedContent?['modern_development'] ??
              'Loading modern development information...',
        ),
        SizedBox(height: 1.5.h),

        DestinationExpandableCard(
          title: 'Visitor Guide',
          icon: IconsaxPlusBold.info_circle,
          content: generatedContent?['visitor_guide'] ??
              'Loading visitor guide information...',
        ),
      ],
    );
  }
}
