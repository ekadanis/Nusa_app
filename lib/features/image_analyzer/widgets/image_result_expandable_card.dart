import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/util/extensions.dart';
import 'package:nusa_app/widgets/custom_section.dart';
import 'package:nusa_app/core/styles.dart';

class ImageResultExpandableCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final String content;

  const ImageResultExpandableCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.content,
  }) : super(key: key);

  @override
  State<ImageResultExpandableCard> createState() =>
      _ImageResultExpandableCardState();
}

class _ImageResultExpandableCardState extends State<ImageResultExpandableCard> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return CustomSection(
      icon: widget.icon,
      title: widget.title,
      trailing: InkWell(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isExpanded
                  ? IconsaxPlusBold.arrow_up_1
                  : IconsaxPlusBold.arrow_down,
              size: 20,
              color: AppColors.grey50,
            ),
          ],
        ),
      ),
      child: _isExpanded
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: Styles.smSpacing),
                Text(
                  widget.content.isNotEmpty 
                      ? widget.content 
                      : 'Information not available',
                  style: context.textTheme.bodyMedium,
                ),
              ],
            )
          : null,
    );
  }
}
