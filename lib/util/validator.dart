import '../l10n/l10n.dart';
import 'package:flutter/material.dart';

class Validator {
  Validator({required this.context});

  final BuildContext context;

  String? emptyValidator(String? text) {
    if (text == null) return "kolom ini tidak boleh kosong";
    if (text.trim().isEmpty) return "kolom ini tidak boleh kosong";
    return null;
  }

  String? emailValidator(String? email) {
    const emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final emailRegExp = RegExp(emailPattern);

    if (email == null || email.trim().isEmpty) {
      return "kolom ini tidak boleh kosong";
    } else if (!emailRegExp.hasMatch(email)) {
      return "Email salah";
    }
    return null;
  }
}
