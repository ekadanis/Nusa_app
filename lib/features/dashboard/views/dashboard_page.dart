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
    return AutoTabsScaffold(
      routes: [HomeRoute(), NusaBotRoute(), FeedsRoute(), AccountRoute()],
      bottomNavigationBuilder: (_, tabsRouter) {
        return Container(
          padding:
              EdgeInsets.only(top: Styles.xxsSpacing, bottom: Styles.smSpacing),
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: Styles.defaultShadow,
          ),          child: NavigationBar(
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
              elevation: 0,
              onPressed: () {
                context.router.push(ImageAnalyzerRoute());
              },
              child: const Icon(IconsaxPlusBold.scan),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}