import 'package:flutter/material.dart';

class NusaTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool readOnly;
  final IconData? suffixIcon;

  const NusaTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.readOnly = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey[300]!),
    );

    return TextField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[100], // Background light grey
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.grey[400]),
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon, color: Colors.grey[400], size: 18)
            : null,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        border: border,
        enabledBorder: border,
        focusedBorder: readOnly
            ? border
            : const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: Colors.blueAccent),
              ),
      ),
    );
  }
}
