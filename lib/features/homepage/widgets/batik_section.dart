import 'package:flutter/material.dart';
import '../../../../core/styles.dart';
import '../../../../widgets/site_card.dart';
import 'section_header.dart';
import 'filter_chip_widget.dart';

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
                label: "Popular",
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
                title: "Batik Parang",
                location: "Solo, Central Java",
                imageUrl: "https://images.unsplash.com/photo-1516613835066-91cb1a42dda4",
                onTap: () {},
                onFavorite: () {},
              ),
              const SizedBox(width: Styles.mdSpacing),
              SiteCard(
                title: "Batik Mega Mendung",
                location: "Cirebon, West Java",
                imageUrl: "https://images.unsplash.com/photo-1591731784541-238d888f77e7",
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