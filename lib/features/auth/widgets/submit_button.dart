import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:nusa_app/core/app_colors.dart';

class SubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final String text;

  const SubmitButton(
      {super.key,
      required this.isLoading,
      required this.onPressed,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48, // Sesuai tinggi tombol UI kamu
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.nusa90, // Warna biru solid dari UI
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Rounded sesuai gambar
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
      ),
    );
  }
}
