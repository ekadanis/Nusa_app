import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AIInfoSection extends StatelessWidget {
  final int userLevel;

  const AIInfoSection({
    super.key,
    required this.userLevel,
  });
  String get _difficultyText {
    if (userLevel <= 3) return 'Basic';
    if (userLevel <= 6) return 'Intermediate';
    if (userLevel <= 8) return 'Advanced';
    return 'Expert';
  }

  Color _getDifficultyColor() {
    if (userLevel <= 3) return Colors.green;
    if (userLevel <= 6) return Colors.blue;
    if (userLevel <= 8) return Colors.deepPurple;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 2.5.h,
            offset: Offset(0, 1.2.h),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Orange bar
            Container(
              width: 2.w,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(3.w),
                  bottomLeft: Radius.circular(3.w),
                ),
              ),
            ),
            // Content area
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(3.w),
                    bottomRight: Radius.circular(3.w),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Row(
                    children: [
                      Icon(
                        Icons.flash_on,
                        color: Colors.orange,
                        size: 6.w,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Dynamic Questions 🤖',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: Colors.grey.shade800,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.sp,
                                      ),
                                ),
                                SizedBox(width: 2.w),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.5.w, vertical: 0.7.h),
                                  decoration: BoxDecoration(
                                    color: _getDifficultyColor(),
                                    borderRadius: BorderRadius.circular(2.w),
                                  ),
                                  child: Text(
                                    _difficultyText,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.sp,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.2.h),
                            Text(
                              'Adaptive questions that match your level with fresh content every time!',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.grey.shade600,
                                    height: 1.3,
                                    fontSize: 13.sp,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
