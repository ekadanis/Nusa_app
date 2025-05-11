import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hireka_mobile/core/app_colors.dart';
import 'package:hireka_mobile/core/styles.dart';
import 'package:hireka_mobile/l10n/l10n.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:hireka_mobile/routes/router.dart';

@RoutePage()
class InfoCenterPage extends StatelessWidget {
  const InfoCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Ini Halaman Info Center'),
      ),
    );
  }
}
