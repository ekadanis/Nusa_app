import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/styles.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final Function()? onSeeAll;

  const SectionHeader({
    Key? key,
    required this.title,
    this.onSeeAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Styles.smPadding,
        horizontal: Styles.mdPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: Text(
                "See All",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.primary50,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
        ],
      ),
    );
  }
}