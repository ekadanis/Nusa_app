import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/styles.dart';

class FeaturedBanner extends StatelessWidget {
  final String title;
  final String image;
  final Function()? onTap;
  final String? buttonText;

  const FeaturedBanner({
    Key? key,
    required this.title,
    required this.image,
    this.onTap,
    this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(
        horizontal: Styles.mdPadding,
        vertical: Styles.smPadding,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
        boxShadow: Styles.defaultShadow,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          // Tambahkan gradient overlay untuk readability text
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.black.withOpacity(0.6),
              Colors.black.withOpacity(0.3),
              Colors.transparent,
            ],
          ),
        ),
        padding: const EdgeInsets.all(Styles.mdPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2, // Berikan lebih banyak ruang untuk title
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Left align untuk readability
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          height: 1.2, // Line height untuk readability
                        ),
                    maxLines: 3, // Izinkan lebih banyak lines
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left, // Left align
                  ),
                ],
              ),
            ),
            SizedBox(width: Styles.mdPadding), // Spacing antara text dan button
            if (buttonText != null)
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.warning50.withOpacity(0.4), // Kurangi opacity untuk natural look
                      offset: Offset(0, 4), // Pindahkan shadow ke bawah
                      blurRadius: 8, // Kurangi blur radius
                      spreadRadius: 0, // Hilangkan spread radius
                    ),
                  ],
                  borderRadius: BorderRadius.circular(8), // Sesuaikan dengan button radius
                ),
                child: ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.warning50,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: Styles.mdPadding,
                      vertical: Styles.smPadding,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Konsisten dengan container shadow
                    ),
                    elevation: 0, // Hilangkan default elevation
                  ),
                  child: Text(
                    buttonText!,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}