import 'package:flutter/material.dart';
import '../../../../core/styles.dart';
import '../../../../widgets/site_card.dart';
import 'section_header.dart';
import 'filter_chip_widget.dart';

class CulturalSitesSection extends StatelessWidget {
  const CulturalSitesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: "Cultural Sites",
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
                label: "Popular",
              ),
              FilterChipWidget(
                label: "Recommended",
              ),
            ],
          ),
        ),
        const SizedBox(height: Styles.smSpacing),
        SizedBox(
          height: 220,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: Styles.mdPadding),
            children: [
              SiteCard(
                title: "Candi Borobudur",
                location: "Magelang, Central Java",
                imageUrl: "https://images.unsplash.com/photo-1565967511849-76a60a516170",
                onTap: () {},
                onFavorite: () {},
              ),
              const SizedBox(width: Styles.mdSpacing),
              SiteCard(
                title: "Candi Borobudur",
                location: "Magelang, Central Java",
                imageUrl: "https://images.unsplash.com/photo-1565967511849-76a60a516170",
                onTap: () {},
                onFavorite: () {},
                isFavorite: true,
              ),
              const SizedBox(width: Styles.mdSpacing),
              SiteCard(
                title: "Candi Prambanan",
                location: "Yogyakarta, DIY",
                imageUrl: "https://images.unsplash.com/photo-1588668214407-6ea9a6d8c272",
                onTap: () {},
                onFavorite: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}