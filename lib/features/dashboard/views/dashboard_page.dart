import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/core/styles.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:nusa_app/routes/router.dart';

@RoutePage()
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {  @override
  Widget build(BuildContext context) {    return AutoTabsScaffold(
        routes: [
          HomeRoute(),
          NusaBotRoute(),
          ImageAnalyzerRoute(),
          FeedsRoute(),
          AccountRoute(),
        ],
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
                NavigationDestination(
                  icon: const Icon(IconsaxPlusBold.home),
                  label: 'HomePage',
                ),
                NavigationDestination(
                  icon: const Icon(IconsaxPlusBold.airdrop),
                  label: 'NusaBot',
                ),
                NavigationDestination(
                  icon: const Icon(IconsaxPlusBold.scan),
                  label: 'Scan',
                ),
                NavigationDestination(
                  icon: const Icon(IconsaxPlusBold.document_1),
                  label: 'Feed',
                ),
                NavigationDestination(
                  icon: const Icon(IconsaxPlusBold.profile_circle),
                  label: 'Profil',
                ),
              ],
            ),
          );
        });
  }
}
