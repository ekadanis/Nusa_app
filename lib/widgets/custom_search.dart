import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/styles.dart';

class SearchWidget extends StatelessWidget {
  final String hintText;
  final Function()? onTap;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  const SearchWidget({
    Key? key,
    this.hintText = "Find your culture",
    this.onTap,
    this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Styles.mdPadding,
        vertical: Styles.smPadding,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(Styles.mdRadius),
        boxShadow: Styles.defaultShadow,
      ),
      child: TextField(
        controller: controller,
        onTap: onTap,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.grey40,
              ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.grey50,
            size: Styles.mdIcon,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }
}