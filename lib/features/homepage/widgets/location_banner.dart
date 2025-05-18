import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/styles.dart';

class LocationBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function()? onTap;

  const LocationBanner({
    Key? key,
    required this.title,
    required this.subtitle,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: Styles.mdPadding,
        vertical: Styles.smPadding,
      ),
      padding: const EdgeInsets.all(Styles.mdPadding),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(Styles.mdRadius),
        boxShadow: Styles.defaultShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.star,
                color: Colors.white,
                size: Styles.lgIcon,
              ),
              const SizedBox(width: Styles.xsSpacing),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: Styles.xsSpacing),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                ),
          ),
          const SizedBox(height: Styles.mdSpacing),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary50,
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: const Text("Turn On Location"),
          ),
        ],
      ),
    );
  }
}