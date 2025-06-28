import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_colors.dart';

class QuestionOption extends StatelessWidget {
  final String option;
  final String optionLetter;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final VoidCallback onTap;

  const QuestionOption({
    super.key,
    required this.option,
    required this.optionLetter,
    required this.isSelected,
    required this.isCorrect,
    required this.isWrong,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.white;
    Color borderColor = AppColors.grey20;
    Color textColor = AppColors.grey90;

    if (isCorrect) {
      backgroundColor = AppColors.success.withOpacity(0.1);
      borderColor = AppColors.success;
      textColor = AppColors.success;
    } else if (isWrong) {
      backgroundColor = AppColors.error.withOpacity(0.1);
      borderColor = AppColors.error;
      textColor = AppColors.error;
    } else if (isSelected) {
      backgroundColor = AppColors.primary50.withOpacity(0.1);
      borderColor = AppColors.primary50;
      textColor = AppColors.primary50;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Option Letter
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: isCorrect
                    ? AppColors.success
                    : isWrong
                        ? AppColors.error
                        : isSelected
                            ? AppColors.primary50
                            : AppColors.grey20,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  optionLetter,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: isSelected || isCorrect || isWrong
                            ? Colors.white
                            : AppColors.grey90,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),

            SizedBox(width: 4.w),

            // Option Text
            Expanded(
              child: Text(
                option,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),

            // Check/Cross Icon
            if (isCorrect || isWrong)
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? AppColors.success : AppColors.error,
                size: 6.w,
              ),
          ],
        ),
      ),
    );
  }
}
