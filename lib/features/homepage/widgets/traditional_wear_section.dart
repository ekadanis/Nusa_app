import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/styles.dart';
import '../../../../widgets/site_card.dart';
import 'section_header.dart';
import 'filter_chip_widget.dart';

class TraditionalWearSection extends StatelessWidget {
  const TraditionalWearSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: "Tradtional Wear",
          onSeeAll: () {},
        ),
        const SizedBox(height: Styles.xsSpacing),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: Styles.mdPadding),
            children: const [
              FilterChipWidget(label: "Discover", isSelected: true),
              FilterChipWidget(label: "Most Like"),
              FilterChipWidget(label: "Recommended"),
            ],
          ),
        ),        const SizedBox(height: Styles.smSpacing),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: Styles.mdPadding),
          child: IntrinsicHeight(
            child: Row(
              children: [
                SiteCard(
                  title: "Candi Borobudur",
                  location: "Magelang, Central Java",
                  imageUrl:
                      "https://images.unsplash.com/photo-1565967511849-76a60a516170",
                  onTap: () {},
                  onFavorite: () {},
                  buttonText: "Kategori",
                  locationIcon: Icon(
                    IconsaxPlusBold.location,
                    color: AppColors.success50,
                    size: 16,
                  ),
                ),
              const SizedBox(width: Styles.mdSpacing),
              SiteCard(
                title: "Candi Borobudur",
                location: "Magelang, Central Java",
                imageUrl:
                    "https://images.unsplash.com/photo-1565967511849-76a60a516170",
                onTap: () {},
                onFavorite: () {},
                isFavorite: true,
                buttonText: "Kategori",
                locationIcon: Icon(
                  IconsaxPlusBold.location,
                  color: AppColors.success50,
                  size: 16,
                ),
              ),
              const SizedBox(width: Styles.mdSpacing),
              SiteCard(
                title: "Candi Prambanan",
                location: "Yogyakarta, DIY",
                imageUrl:
                    "https://images.unsplash.com/photo-1588668214407-6ea9a6d8c272",
                onTap: () {},
                onFavorite: () {},
                buttonText: "Kategori",
                locationIcon: Icon(
                  IconsaxPlusBold.location,
                  color: AppColors.success50,
                  size: 16,
                ),              ),
            ],
          ),
        ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
