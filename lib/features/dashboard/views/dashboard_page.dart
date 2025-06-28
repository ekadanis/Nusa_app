import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/core/styles.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:nusa_app/features/nusabot/services/chatbot_service.dart';
import 'package:nusa_app/routes/router.dart';
import 'package:sizer/sizer.dart';

// Custom FloatingActionButtonLocation yang tidak terpengaruhi snackbar dan responsive untuk semua device
class FixedCenterDockedFABLocation extends FloatingActionButtonLocation {
  const FixedCenterDockedFABLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Hitung posisi X di tengah layar
    final double fabX = (scaffoldGeometry.scaffoldSize.width -
            scaffoldGeometry.floatingActionButtonSize.width) /
        2.0;

    // Posisi Y menggunakan Sizer untuk konsistensi - diturunkan agar tidak mepet dengan text
    final double fabY = scaffoldGeometry.scaffoldSize.height -
        scaffoldGeometry.floatingActionButtonSize.height -
        (4.h);

    return Offset(fabX, fabY);
  }
}

@RoutePage()
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _listenerAttached = false;
  int _lastTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      resizeToAvoidBottomInset: true,
      routes: const [
        HomeRoute(),
        NusaBotRoute(),
        FeedsRoute(),
        ProfileRoute(),
      ],
      bottomNavigationBuilder: (context, tabsRouter) {
        // Pasang listener hanya sekali
        if (!_listenerAttached) {
          tabsRouter.addListener(() {
            if (_lastTabIndex == 1 && tabsRouter.activeIndex != 1) {
              ChatbotService().stopTts();
              print('[TTS] Dihentikan karena berpindah dari tab NusaBot');
            }
            _lastTabIndex = tabsRouter.activeIndex;
          });
          _listenerAttached = true;
        }

        return SafeArea(
          child: Container(
            height: 10.h,
            padding: EdgeInsets.only(
              top: Styles.xxsSpacing,
              bottom: 1.h,
              left: 2.w,
              right: 2.w,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary50.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
                BoxShadow(
                  color: AppColors.primary50.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: NavigationBar(
              selectedIndex: tabsRouter.activeIndex,
              onDestinationSelected: tabsRouter.setActiveIndex,
              destinations: [
                Padding(
                  padding: EdgeInsets.only(right: 2.w),
                  child: const NavigationDestination(
                    icon: Icon(IconsaxPlusBold.home),
                    label: 'Home',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: const NavigationDestination(
                    icon: Icon(IconsaxPlusBold.airdrop),
                    label: 'NusaBot',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: const NavigationDestination(
                    icon: Icon(IconsaxPlusBold.document_1),
                    label: 'Feed',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 2.w),
                  child: const NavigationDestination(
                    icon: Icon(IconsaxPlusBold.profile_circle),
                    label: 'Profile',
                  ),
                ),
              ],
            ),
          ),
        );
      },
      floatingActionButton: MediaQuery.of(context).viewInsets.bottom > 0
          ? null
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.w),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary50.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: AppColors.primary50.withOpacity(0.15),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: FloatingActionButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.w),
                ),
                elevation: 0,
                backgroundColor: AppColors.primary50,
                onPressed: () {
                  context.router.push(const ImageAnalyzerRoute());
                },
                child: Icon(
                  IconsaxPlusBold.scan,
                  color: Colors.white,
                  size: 6.w,
                ),
              ),
            ),
      floatingActionButtonLocation: const FixedCenterDockedFABLocation(),
    );
  }
}
