import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_colors.dart';
import '../../../models/quiz_models.dart';

class QuestionView extends StatelessWidget {
  final Question question;
  final int currentIndex;
  final int totalQuestions;
  final int? selectedAnswerIndex;
  final bool isAnswered;
  final Function(int) onAnswerSelect;
  final VoidCallback onNextPressed;
  final bool isLastQuestion;
  final VoidCallback? onShowExplanation;

  const QuestionView({
    super.key,
    required this.question,
    required this.currentIndex,
    required this.totalQuestions,
    required this.selectedAnswerIndex,
    required this.isAnswered,
    required this.onAnswerSelect,
    required this.onNextPressed,
    required this.isLastQuestion,
    this.onShowExplanation,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress and Score
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${currentIndex + 1} of $totalQuestions',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.grey50,
                    ),
              ),
              Row(
                children: [
                  Icon(Icons.check_circle, color: AppColors.success, size: 5.w),
                  SizedBox(width: 1.w),
                  Text(
                    '10 pts',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 1.h),

          // Progress Bar
          LinearProgressIndicator(
            value: (currentIndex + 1) / totalQuestions,
            backgroundColor: AppColors.grey20,
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.primary50),
          ),

          SizedBox(height: 4.h),

          // Question
          Text(
            question.question,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),

          SizedBox(height: 4.h),

          // Options
          Expanded(
            child: ListView.builder(
              itemCount: question.options.length,
              itemBuilder: (context, index) {
                final option = question.options[index];
                final isSelected = selectedAnswerIndex == index;
                final isCorrect = index == question.correctAnswerIndex;
                final showResult = isAnswered;

                Color backgroundColor;
                Color borderColor;

                if (showResult) {
                  if (isCorrect) {
                    backgroundColor = Colors.green.shade50;
                    borderColor = Colors.green;
                  } else if (isSelected && !isCorrect) {
                    backgroundColor = Colors.red.shade50;
                    borderColor = Colors.red;
                  } else {
                    backgroundColor = Colors.white;
                    borderColor = Colors.grey.shade300;
                  }
                } else {
                  backgroundColor =
                      isSelected ? AppColors.primary10 : Colors.white;
                  borderColor =
                      isSelected ? AppColors.primary50 : Colors.grey.shade300;
                }

                return Padding(
                  padding: EdgeInsets.only(bottom: 2.h),
                  child: GestureDetector(
                    onTap: isAnswered ? null : () => onAnswerSelect(index),
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor, width: 1.5),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.grey20.withOpacity(0.5),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : [],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: showResult
                                  ? (isCorrect
                                      ? Colors.green
                                      : (isSelected
                                          ? Colors.red
                                          : Colors.grey.shade200))
                                  : (isSelected
                                      ? AppColors.primary50
                                      : Colors.grey.shade200),
                            ),
                            child: Center(
                              child: showResult
                                  ? Icon(
                                      isCorrect
                                          ? Icons.check
                                          : (isSelected ? Icons.close : null),
                                      color: Colors.white,
                                      size: 5.w,
                                    )
                                  : (isSelected
                                      ? Icon(Icons.check,
                                          color: Colors.white, size: 5.w)
                                      : Text(
                                          String.fromCharCode(
                                              65 + index), // A, B, C, D...
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              option,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: isSelected
                                        ? AppColors.grey90
                                        : AppColors.grey70,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (isAnswered &&
              selectedAnswerIndex != null &&
              selectedAnswerIndex != question.correctAnswerIndex &&
              question.explanation != null &&
              question.explanation!.isNotEmpty &&
              onShowExplanation != null) ...[
            SizedBox(height: 2.h),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onShowExplanation,
                  icon: const Icon(Icons.lightbulb, color: Colors.orange),
                  label: Text(
                    'Show Explanation',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.orange,
                        ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.orange,
                    side: const BorderSide(color: Colors.orange),
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],

          // Next Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isAnswered ? onNextPressed : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary50,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                isLastQuestion ? 'Finish' : 'Next',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
