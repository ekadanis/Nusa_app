import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/styles.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20.h + 15, // Tambahan space untuk kontainer putih bawah
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background AppBar dengan banner
          Container(
            height: 20.h,
            padding: const EdgeInsets.all(Styles.mdPadding),
            decoration: BoxDecoration(
              color: AppColors.primary50,
              image: DecorationImage(
                image: const AssetImage('assets/banner/banner.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  AppColors.primary50,
                  BlendMode.multiply,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only( bottom: 80),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      'assets/avatar/avatar-1.png',
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: Styles.mdSpacing), // Increased from smSpacing for better spacing

                  Expanded( // Wrapped in Expanded to ensure proper text layout
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Zhafran Arise !",
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold, // Added bold for better visibility
                              ),
                        ),
                        const SizedBox(height: 2), // Added small consistent spacing
                        Row(
                          children: [
                            Text(
                              "Welcome Back",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                            ),
                            const SizedBox(width: 4),
                            const Text("👋", style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Notification icon with proper alignment
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: const Icon(
                     IconsaxPlusBold.notification,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: double.infinity,
                height: 33,
                clipBehavior: Clip.antiAlias,
                decoration: const ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Styles.lgRadius),
                      topRight: Radius.circular(Styles.lgRadius),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}