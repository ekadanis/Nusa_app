import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MotivationSection extends StatelessWidget {
  const MotivationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.star,
            color: Colors.amber,
            size: 8.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'Keep learning! Every step brings you closer to cultural mastery.',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.amber.shade800,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            'Explore other categories to expand your knowledge!',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.amber.shade700,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
