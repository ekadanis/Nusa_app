import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/styles.dart';

class FeaturedBanner extends StatelessWidget {
  final String title;
  final String imageUrl;
  final Function()? onTap;
  final String? buttonText;

  const FeaturedBanner({
    Key? key,
    required this.title,
    required this.imageUrl,
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
        borderRadius: BorderRadius.circular(Styles.mdRadius),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
        boxShadow: Styles.defaultShadow,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Styles.mdRadius),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.black.withOpacity(0.6),
              Colors.black.withOpacity(0.3),
              Colors.black.withOpacity(0.1),
            ],
          ),
        ),
        padding: const EdgeInsets.all(Styles.mdPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (buttonText != null)
              ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.warning50,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: Styles.mdPadding,
                    vertical: Styles.smPadding,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(buttonText!),
              ),
          ],
        ),
      ),
    );
  }
}