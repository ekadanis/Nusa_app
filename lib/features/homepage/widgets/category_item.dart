import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/styles.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  final Widget icon;
  final Function()? onTap;

  const CategoryItem({
    Key? key,
    required this.title,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
            ),
            child: icon,
          ),
          const SizedBox(height: Styles.xxsSpacing),
          Text(
            title,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.grey70,
                  fontWeight: FontWeight.w500,
                ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}