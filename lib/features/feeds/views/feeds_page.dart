import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/core/styles.dart';
import 'package:nusa_app/l10n/l10n.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:nusa_app/routes/router.dart';

@RoutePage()
class FeedsPage extends StatelessWidget {
  const FeedsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Ini Halaman Feed'),
      ),
    );
  }
}
