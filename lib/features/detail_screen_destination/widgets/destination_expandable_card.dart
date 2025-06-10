import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/util/extensions.dart';
import 'package:nusa_app/widgets/custom_section.dart';
import 'package:nusa_app/core/styles.dart';

class DestinationExpandableCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final String content;

  const DestinationExpandableCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.content,
  }) : super(key: key);

  @override
  State<DestinationExpandableCard> createState() =>
      _DestinationExpandableCardState();
}

class _DestinationExpandableCardState extends State<DestinationExpandableCard> {
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
      hasSpacing: false,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.topLeft,
        curve: Curves.easeInOut,
        child: !_isExpanded
            ? const SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.only(top: Styles.mdPadding),
                child: Text(
                  widget.content,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey60,
                    height: 1.5,
                  ),
                ),
              ),
      ),
    );
  }
}
