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

  const ExpandableCard({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
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
            ? SizedBox.shrink()
            : Container(
                decoration: BoxDecoration(color: AppColors.primary20),
                child: Padding(
                    padding: const EdgeInsets.only(top: Styles.mdPadding),
                    child: Text(
                      'Tari Reog biasanya ditampilkan dalam acara-acara budaya, perayaan, atau penyambutan tamu penting. Dalam satu pertunjukan, terdapat beberapa unsur karakter seperti Warok (tokoh sakti), Jathil (penari kuda lumping), dan Barongan. Selain sebagai hiburan, Tari Reog juga mengandung nilai-nilai spiritual dan filosofi tentang perjuangan, keberanian, serta hubungan manusia dengan alam dan leluhur.',
                      style: context.textTheme.bodySmall,
                    )),
              ),
      ),
    );
  }
}
