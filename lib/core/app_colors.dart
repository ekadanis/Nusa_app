import 'package:flutter/cupertino.dart';

class AppColors {
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const background = Color(0xFFFAFAFA);

  static const primary90 = Color(0xFF070d18);
  static const primary80 = Color(0xFF1a3660);
  static const primary70 = Color(0xFF28508f);
  static const primary60 = Color(0xFF356bbf);
  static const primary50 = Color(0xFF4286EF);
  static const primary40 = Color(0xFF849BEB);
  static const primary30 = Color(0xFFA3B4F0);
  static const primary20 = Color(0xFFC1CDF5);
  static const primary10 = Color(0xFFE0E6FA);
  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary40, primary60],
  );

  static const grey90 = Color(0xFF131414);
  static const grey80 = Color(0xFF262728);
  static const grey70 = Color(0xFF393B3D);
  static const grey60 = Color(0xFF4C4E51);
  static const grey50 = Color(0xFF5F6265);
  static const grey40 = Color(0xFF7F8184);
  static const grey30 = Color(0xFF9FA1A3);
  static const grey20 = Color(0xFFBFC0C1);
  static const grey10 = Color(0xFFDFE0E0);

  static const danger90 = Color(0xFF190505);
  static const danger80 = Color(0xFF631414);
  static const danger70 = Color(0xFF941d1d);
  static const danger60 = Color(0xFFc62727);
  static const danger50 = Color(0xFFf73131);
  static const danger40 = Color(0xFFf95a5a);
  static const danger30 = Color(0xFFfa8383);
  static const danger20 = Color(0xFFfcadad);
  static const danger10 = Color(0xFFfeeaea);

  static const warning90 = Color(0xFF190a04);
  static const warning80 = Color(0xFF662910);
  static const warning70 = Color(0xFF993d19);
  static const warning60 = Color(0xFFcc5221);
  static const warning50 = Color(0xFFff6629);
  static const warning40 = Color(0xFFff8554);
  static const warning30 = Color(0xFFffa37f);
  static const warning20 = Color(0xFFffc2a9);
  static const warning10 = Color(0xFFfff0ea);

  static const success90 = Color(0xFF07130c);
  static const success80 = Color(0xFF1d4b30);
  static const success70 = Color(0xFF2b7048);
  static const success60 = Color(0xFF3a9660);
  static const success50 = Color(0xFF48bb78);
  static const success40 = Color(0xFF6dc993);
  static const success30 = Color(0xFF91d6ae);
  static const success20 = Color(0xFFb6e4c9);
  static const success10 = Color(0xFFedf8f2);

  static const yellow90 = Color(0xFF181407);
  static const yellow80 = Color(0xFF5e501e);
  static const yellow70 = Color(0xFF8e792d);
  static const yellow60 = Color(0xFFbda13c);
  static const yellow50 = Color(0xFFecc94b);
  static const yellow40 = Color(0xFFf0d46f);
  static const yellow30 = Color(0xFFf4df93);
  static const yellow20 = Color(0xFFf7e9b7);
  static const yellow10 = Color(0xFFfdfaed);

  static const purple90 = Color(0xFF0e0819);
  static const purple80 = Color(0xFF372066);
  static const purple70 = Color(0xFF532f99);
  static const purple60 = Color(0xFF6e3fcc);
  static const purple50 = Color(0xFF8a4fff);
  static const purple40 = Color(0xFFa172ff);
  static const purple30 = Color(0xFFb995ff);
  static const purple20 = Color(0xFFd0b9ff);
  static const purple10 = Color(0xFFf3edff);

  static Color lighten(Color c, [int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    final p = percent / 100;
    return Color.fromARGB(
      c.alpha,
      c.red + ((255 - c.red) * p).round(),
      c.green + ((255 - c.green) * p).round(),
      c.blue + ((255 - c.blue) * p).round(),
    );
  }

  static Color darken(Color c, [int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    final f = 1 - percent / 100;
    return Color.fromARGB(
      c.alpha,
      (c.red * f).round(),
      (c.green * f).round(),
      (c.blue * f).round(),
    );
  }
}
