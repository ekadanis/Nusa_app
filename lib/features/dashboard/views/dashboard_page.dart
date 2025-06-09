import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/core/styles.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:nusa_app/routes/router.dart';

// Custom FloatingActionButtonLocation yang tidak terpengaruhi snackbar
class FixedCenterDockedFABLocation extends FloatingActionButtonLocation {
  const FixedCenterDockedFABLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Hitung posisi X di tengah layar
    final double fabX = (scaffoldGeometry.scaffoldSize.width - scaffoldGeometry.floatingActionButtonSize.width) / 2.0;
    
    // Posisi Y fixed dari bottom tanpa terpengaruhi snackbar atau perubahan layout
    final double fabY = scaffoldGeometry.scaffoldSize.height - 
                       scaffoldGeometry.bottomSheetSize.height - 
                       scaffoldGeometry.floatingActionButtonSize.height - 
                       kBottomNavigationBarHeight / 2;
    
    return Offset(fabX, fabY);
  }
}

@RoutePage()
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      resizeToAvoidBottomInset: false, // Mencegah layout berubah saat snackbar muncul
      routes: [HomeRoute(), NusaBotRoute(), FeedsRoute(), AccountRoute()],
      bottomNavigationBuilder: (_, tabsRouter) {        return Container(
          height: kBottomNavigationBarHeight + 16, // Fixed height untuk konsistensi
          padding: EdgeInsets.only(
            top: Styles.xxsSpacing, 
            bottom: Styles.smSpacing,
            left: 8,
            right: 8,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: Styles.defaultShadow,
          ),child: NavigationBar(
            selectedIndex: tabsRouter.activeIndex,
            onDestinationSelected: tabsRouter.setActiveIndex,
            destinations: [

              Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: NavigationDestination(
                  icon: const Icon(IconsaxPlusBold.home),
                  label: 'HomePage',
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 40.0),
                child: NavigationDestination(
                  icon: const Icon(IconsaxPlusBold.airdrop),
                  label: 'NusaBot',
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 40.0),
                child: NavigationDestination(
                  icon: const Icon(IconsaxPlusBold.document_1),
                  label: 'Feed',
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: NavigationDestination(
                  icon: const Icon(IconsaxPlusBold.profile_circle),
                  label: 'Profil',
                ),
              ),
            ],
          ),
        );
      },      floatingActionButton: MediaQuery.of(context).viewInsets.bottom > 0 
          ? null 
          : FloatingActionButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 8, // Elevasi lebih tinggi agar selalu di atas
              backgroundColor: AppColors.primary50,
              onPressed: () {
                context.router.push(ImageAnalyzerRoute());
              },
              child: const Icon(
                IconsaxPlusBold.scan,
                color: Colors.white,
              ),
            ),
      floatingActionButtonLocation: const FixedCenterDockedFABLocation(),
    );
  }
}