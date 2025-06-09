import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/core/styles.dart';
import 'package:nusa_app/l10n/l10n.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:nusa_app/routes/router.dart';

@RoutePage()
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      AutoTabsScaffold(
          routes: [HomeRoute(), NusaBotRoute(), FeedsRoute(), AccountRoute()],
          bottomNavigationBuilder: (_, tabsRouter) {
            return Container(
              padding: EdgeInsets.only(
                  top: Styles.xxsSpacing, bottom: Styles.smSpacing),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: Styles.defaultShadow,
              ),
              child: NavigationBar(
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
          }),
      Positioned(
        bottom: MediaQuery.of(context).viewInsets.bottom == 0 ? 52 : -100,
        left: MediaQuery.of(context).size.width / 2 -
            28, // Tengah horizontal, setengah dari lebar 56
        child: Container(
          decoration: BoxDecoration(
            boxShadow: Styles.defaultShadow,
          ),
          width: 56,
          height: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding:
                  EdgeInsets.zero, // memastikan tidak ada padding yang aneh
            ),
            onPressed: () {
              context.router.push(ImageAnalyzerRoute());
            },
            child: const Icon(
              IconsaxPlusBold.scan,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      ),
    ]);

    //   floatingActionButton: FloatingActionButton(
    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    //     elevation: 0,
    //     onPressed: () {
    //       context.router.push(ImageAnalyzerRoute());
    //     },
    //     child: const Icon(IconsaxPlusBold.scan),
    //   ),
    //   floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    //   resizeToAvoidBottomInset: true,
    // );
  }
}
