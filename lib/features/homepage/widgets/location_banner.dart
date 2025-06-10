import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/styles.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

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
              Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(Styles.xsPadding),
                decoration: BoxDecoration(
                  color: AppColors.grey20.withValues(alpha: 0.30),
                  borderRadius: BorderRadius.circular(Styles.mdRadius),
                ),
                child: const Icon(
                  IconsaxPlusBold.magic_star,
                  color: Colors.white,
                  size: Styles.lgIcon,
                ),
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
                  color: Colors.white.withValues(alpha: 0.8),
                ),
          ),
          const SizedBox(height: Styles.mdSpacing),          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: onTap != null ? Colors.white : Colors.grey.shade300,
              minimumSize: const Size(double.infinity, 44),
              elevation: onTap != null ? 2 : 0,
              shadowColor: Colors.black.withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (onTap == null) ...[
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4286EF)),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  onTap != null ? "Turn On Location" : "Getting Location...",
                  style: TextStyle(
                    color: const Color(0xFF4286EF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
