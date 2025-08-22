import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final bool isUnlocked;
  final IconData lockedIcon;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.isUnlocked,
    this.lockedIcon = IconsaxPlusLinear.lock,
  });
}