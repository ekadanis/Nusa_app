import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/routes/router.dart';
import 'package:sizer/sizer.dart'; // pastikan sudah di-import

class AskNusaBotFloating extends StatelessWidget {
  const AskNusaBotFloating({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 8.h, // kira-kira 70px relatif terhadap tinggi layar
      right: 6.w,  // 5% dari lebar layar
      child: GestureDetector(
        onTap: () {
          context.router.push(
            const DashboardRoute(
              children: [NusaBotRoute()],
            ),
          );
        },
        child: Container(
          width: 15.w,   // lebar tombol bulat
          height: 15.w,  // tinggi tombol = lebar agar bulat
          decoration: BoxDecoration(
            color: AppColors.primary50,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(2.w), // padding agar gambar tidak mentok
            child: Image.asset(
              'assets/avatar/ask_nusabot.png',
              width: 30.w,
              height: 30.w,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
