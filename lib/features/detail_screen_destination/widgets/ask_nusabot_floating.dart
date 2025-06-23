import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/routes/router.dart';

class AskNusaBotFloating extends StatelessWidget {
  const AskNusaBotFloating({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 70,
      right: 20,
      child: GestureDetector(
        onTap: () {
          // AutoTabsRouter.of(context).setActiveIndex(1);
          context.router.push(
            const DashboardRoute(
              children: [NusaBotRoute()],
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.nusa90,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 40,
                width: 40,
                child: Image.asset(
                  'assets/avatar/ask_nusabot.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 10),
              const Padding(
                padding: EdgeInsets.only(right: 8), // ✅ padding kanan di sini
                child: Text(
                  "Ask NusaBot",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    letterSpacing: 0.2,
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
