import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/core/styles.dart';
import 'package:nusa_app/l10n/l10n.dart';
import 'package:nusa_app/util/extensions.dart';
import 'package:nusa_app/widgets/custom_paragraph.dart';
import 'package:nusa_app/widgets/custom_section.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class ExpandableCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final String content;

  const ExpandableCard(
      {super.key,
      required this.title,
      required this.icon,
      required this.content});

  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: CustomSection(
        icon: widget.icon,
        title: widget.title,
        trailing: Row(
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
        hasSpacing: false,
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          alignment: Alignment.topLeft,
          curve: Curves.easeInOut,
          child: _isExpanded
              ? Padding(
                  padding: const EdgeInsets.only(top: Styles.mdPadding),
                  child: Text(
                    widget.content,
                    style: context.textTheme.bodySmall,
                    textAlign: TextAlign.justify,
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
