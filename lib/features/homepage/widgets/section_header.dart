import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/styles.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final Function()? onSeeAll;

  const SectionHeader({
    Key? key,
    required this.title,
    this.onSeeAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Styles.smPadding,
        horizontal: Styles.mdPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            // Menggunakan crossAxisAlignment untuk menyelaraskan icon dan text
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // Batasi lebar Row
            children: [
              Container(
                padding: EdgeInsets.all(Styles.xsPadding),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    // === Perbaikan: Menambahkan default case untuk warna ===
                    color: categoryColorPicker(title)),
                child: getCategoryIcon(title),
              ),
              SizedBox(width: Styles.smSpacing), // Menambahkan spasi di sini
              titleParse(context, title),
            ],
          ),
          // === Perbaikan: Sembunyikan tombol "See All" ketika dalam mode pencarian ===
          if (onSeeAll != null && !title.startsWith("Hasil Pencarian untuk"))
            GestureDetector(
              onTap: onSeeAll,
              child: Text(
                "See All",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.primary50,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  categoryColorPicker(String title) {
    switch (title) {
      case 'Local Foods' : return AppColors.localFoods;
      case 'Folk Instruments' : return AppColors.folkInstruments;
      case 'Traditional Wear' : return AppColors.traditionalWear;
      case'Arts & Culture' : return AppColors.artsCulture;
      case'Crafts & Artifacts' : return AppColors.craftArtifacts;
      case'Cultural Sites' : return AppColors.culturalSite;
      default: return AppColors.grey50; // Menggunakan warna abu-abu default untuk hasil pencarian
    }
  }
}

Widget getCategoryIcon(String title) {
  switch (title) {
    case 'Local Foods':
      return SvgPicture.asset('assets/category/local_foods.svg', width: 24, height: 24);
    case 'Folk Instruments':
      return SvgPicture.asset('assets/category/folk_instruments.svg', width: 24, height: 24);
    case 'Traditional Wear':
      return SvgPicture.asset('assets/category/traditional_wear.svg', width: 24, height: 24);
    case 'Arts & Culture':
      return SvgPicture.asset('assets/category/art_culture.svg', width: 24, height: 24);
    case 'Crafts & Artifacts':
      return SvgPicture.asset('assets/category/craft_artifacts.svg', width: 24, height: 24);
    case 'Cultural Sites':
      return SvgPicture.asset('assets/category/cultural_sites.svg', width: 24, height: 24);
  // === Perbaikan: Menambahkan default case untuk ikon ===
    default:
    // Gunakan ikon pencarian atau ikon generik untuk hasil pencarian
      if (title.startsWith("Hasil Pencarian untuk")) {
        return Icon(Icons.search, color: Colors.white, size: 20);
      }
      return const Icon(Icons.error); // fallback jika tidak ditemukan
  }
}

Widget titleParse(BuildContext context, String title) {
  // === Perbaikan: Menggunakan default case yang sudah ada untuk menangani judul pencarian ===
  switch (title) {
    case 'Local Foods':
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Local ',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextSpan(
              text: 'Foods',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.purple50,
              ),
            ),
          ],
        ),
      );
    case 'Folk Instruments':
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Folk ',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextSpan(
              text: 'Instruments',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.success50,
              ),
            ),
          ],
        ),
      );
    case 'Traditional Wear':
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Traditional ',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextSpan(
              text: 'Wear',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.yellow50,
              ),
            ),
          ],
        ),
      );
    case 'Arts & Culture':
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Arts & ',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextSpan(
              text: 'Culture',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.warning50,
              ),
            ),
          ],
        ),
      );
    case 'Crafts & Artifacts':
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Crafts & ',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextSpan(
              text: 'Artifacts',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.danger50,
              ),
            ),
          ],
        ),
      );
    case 'Cultural Sites':
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Cultural ',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextSpan(
              text: 'Sites',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.primary50,
              ),
            ),
          ],
        ),
      );

    default:
    // Ini sudah menangani kasus lain, termasuk "Hasil Pencarian untuk..."
      return Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      );
  }
}
