import 'package:flutter/material.dart';
import '../../../../core/styles.dart';
import '../../../core/app_colors.dart';
import '../../../../widgets/site_card.dart';
import 'section_header.dart';
import 'filter_chip_widget.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class BatikSection extends StatelessWidget {
  const BatikSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: "Batik & Textiles",
          onSeeAll: () {},
        ),
        const SizedBox(height: Styles.xsSpacing),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: Styles.mdPadding),
            children: const [
              FilterChipWidget(
                label: "Discover",
                isSelected: true,
              ),
              FilterChipWidget(
                label: "Most Like",
              ),
              FilterChipWidget(
                label: "Recommended",
              ),
            ],
          ),
        ),
        const SizedBox(height: Styles.smSpacing),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: Styles.mdPadding),
          child: IntrinsicHeight(
            child: Row(
              children: [
                SiteCard(
                  title: "Batik Parang",
                  location: "Solo, Central Java",
                  imageUrl: "https://images.unsplash.com/photo-1565967511849-76a60a516170",
                  locationIcon: Icon(
                    IconsaxPlusBold.location,
                    color: AppColors.success50,
                    size: 16,
                  ),
                  onTap: () {},
                  onFavorite: () {},
                ),
                const SizedBox(width: Styles.mdSpacing),
                SiteCard(
                  title: "Batik Mega Mendung",
                  location: "Cirebon, West Java",
                  imageUrl: "https://images.unsplash.com/photo-1565967511849-76a60a516170",
                  locationIcon: Icon(
                    IconsaxPlusBold.location,
                    color: AppColors.success50,
                    size: 16,
                  ),
                  onTap: () {},
                  onFavorite: () {},
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}