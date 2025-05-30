import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../core/app_colors.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton(
      {super.key, this.backgroundColor, this.iconColor, this.onPressed});
  final Color? backgroundColor;
  final Color? iconColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ??
          () {
            AutoRouter.of(context).maybePop();
          },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: Icon(IconsaxPlusBold.arrow_left_3,
            color: iconColor ?? AppColors.grey20),
      ),
    );
  }
}