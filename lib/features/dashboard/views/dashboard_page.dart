import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/core/styles.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:nusa_app/routes/router.dart';
import 'package:sizer/sizer.dart';

// Custom FloatingActionButtonLocation yang tidak terpengaruhi snackbar dan responsive untuk semua device
class FixedCenterDockedFABLocation extends FloatingActionButtonLocation {
  const FixedCenterDockedFABLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Hitung posisi X di tengah layar
    final double fabX = (scaffoldGeometry.scaffoldSize.width - scaffoldGeometry.floatingActionButtonSize.width) / 2.0;
    
    // Posisi Y menggunakan Sizer untuk konsistensi
    final double fabY = scaffoldGeometry.scaffoldSize.height - 
                       scaffoldGeometry.floatingActionButtonSize.height - 
                       (8.h);
    
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
  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      resizeToAvoidBottomInset: false,
      routes: [HomeRoute(), NusaBotRoute(), FeedsRoute(), AccountRoute()],      bottomNavigationBuilder: (_, tabsRouter) {
        return SafeArea(
          child: Container(
            // Menggunakan Sizer untuk responsive height
            height: 10.h, // Fixed height menggunakan Sizer
            padding: EdgeInsets.only(
              top: Styles.xxsSpacing, 
              bottom: 1.h, // Menggunakan Sizer untuk padding bottom
              left: 2.w, // Menggunakan Sizer untuk padding horizontal
              right: 2.w,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: Styles.defaultShadow,
            ),
            child: NavigationBar(
              selectedIndex: tabsRouter.activeIndex,
              onDestinationSelected: tabsRouter.setActiveIndex,              destinations: [
                Padding(
                  padding: EdgeInsets.only(right: 2.w), // Menggunakan Sizer
                  child: NavigationDestination(
                    icon: const Icon(IconsaxPlusBold.home),
                    label: 'HomePage',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10.w), // Menggunakan Sizer
                  child: NavigationDestination(
                    icon: const Icon(IconsaxPlusBold.airdrop),
                    label: 'NusaBot',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.w), // Menggunakan Sizer
                  child: NavigationDestination(
                    icon: const Icon(IconsaxPlusBold.document_1),
                    label: 'Feed',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 2.w), // Menggunakan Sizer
                  child: NavigationDestination(
                    icon: const Icon(IconsaxPlusBold.profile_circle),
                    label: 'Profil',
                  ),
                ),
              ],
            ),
          ),
        );
      },      floatingActionButton: MediaQuery.of(context).viewInsets.bottom > 0 
          ? null 
          : FloatingActionButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.w)), // Menggunakan Sizer
              elevation: 8,
              backgroundColor: AppColors.primary50,
              onPressed: () {
                context.router.push(ImageAnalyzerRoute());
              },
              child: Icon(
                IconsaxPlusBold.scan,
                color: Colors.white,
                size: 6.w, // Menggunakan Sizer untuk ukuran icon
              ),
            ),
      floatingActionButtonLocation: const FixedCenterDockedFABLocation(),
    );
  }
}