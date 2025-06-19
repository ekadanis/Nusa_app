import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_colors.dart';

class QuizTimer extends StatelessWidget {
  final int timeLeft;
  
  const QuizTimer({
    super.key, 
    required this.timeLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: timeLeft <= 5 ? Colors.red.shade100 : Colors.orange.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            color: timeLeft <= 5 ? Colors.red : Colors.orange.shade800,
            size: 4.w,
          ),
          SizedBox(width: 1.w),
          Text(
            '$timeLeft s',
            style: TextStyle(
              color: timeLeft <= 5 ? Colors.red : Colors.orange.shade800,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
