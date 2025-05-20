import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../core/app_colors.dart';

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
    final TextEditingController textController =
        controller ?? TextEditingController();

    return Container(
      width: double.infinity,
      height: 7.h,
      decoration: ShapeDecoration(
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 2,
            offset: Offset(0, 0),
            spreadRadius: 0,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: Container(
          width: double.infinity,
          decoration: ShapeDecoration(
            color: AppColors.grey10.withValues(alpha: 0.8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 8.0),
                child: Icon(
                  IconsaxPlusLinear.search_normal_1,
                  color: AppColors.grey50,
                  size: 16,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: textController,
                  onTap: onTap,
                  onChanged: onChanged,
                  textAlignVertical: TextAlignVertical.center,
                  style: const TextStyle(
                    color: AppColors.grey70,
                    fontSize: 12,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText.toLowerCase(),
                    hintStyle: const TextStyle(
                      color: AppColors.grey50,
                      fontSize: 10,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w400,
                      height: 1.0,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
