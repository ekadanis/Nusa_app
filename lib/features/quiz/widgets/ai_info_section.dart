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
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
  BoxShadow(
    color: Colors.black.withOpacity(0.20),
    blurRadius: 10,
    offset: Offset(0, 4),
  ),
],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Orange left border stack effect
            Container(
              width: 2.w,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
            ), // Content area
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF7ED), // Warna latar belakang #FFF7ED
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Row(
                    children: [
                      Icon(
                        Icons.flash_on,
                        color: Colors.orange,
                        size: 5.w,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [                            Row(
                              children: [
                                Text(
                                  'Dynamic Questions 🤖',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: Colors.grey.shade800,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                SizedBox(width: 2.w),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                                  decoration: BoxDecoration(
                                    color: _getDifficultyColor(),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _difficultyText,
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.w),
                            Text(
                              'Level-based questions that adapt to your knowledge level!',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.grey.shade600,
                                    height: 1.2,
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
