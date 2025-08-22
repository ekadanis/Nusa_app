import 'package:flutter/material.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/services/firestore_service.dart';

Widget buildCategoryName(String categoryId) {
  return FutureBuilder<String>(
    future: FirestoreService.getCategoryNameById(categoryId),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return SizedBox(
          width: 60,
          height: 12,
          child: LinearProgressIndicator(
            minHeight: 2,
            color: AppColors.primary50,
            backgroundColor: Colors.transparent,
          ),
        );
      }
      if (snapshot.hasError) {
        return const Text(
          "Unknown",
          style: TextStyle(
            fontSize: 12,
            color: Colors.red,
            fontWeight: FontWeight.w600,
          ),
        );
      }
      return Text(
        (snapshot.data?.isNotEmpty ?? false) ? snapshot.data! : "Unknown",
        style: TextStyle(
          fontSize: 12,
          color: AppColors.primary50,
          fontWeight: FontWeight.w600,
        ),
      );
    },
  );
}
