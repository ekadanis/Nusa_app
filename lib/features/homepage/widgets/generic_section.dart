import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // Still needed for Position type
import 'package:sizer/sizer.dart';
import 'package:auto_route/auto_route.dart';
import '../../../core/styles.dart';
import '../../../models/destination_model.dart';
import '../../../routes/router.dart';
import 'section_header.dart';
import 'generic_section/empty_state_widget.dart';
import 'generic_section/items_list_widget.dart';
import 'generic_section/generic_section_controller.dart'; // Still needed for logic like toggle favorite

class GenericSection extends StatefulWidget {
  final String title;
  final List<DestinationModel> items; // items ini sudah difilter dari HomePage
  final String categoryName; // categoryName tetap diperlukan untuk navigasi See All
  final Widget? locationIcon;
  final String? userId;

  const GenericSection({
    Key? key,
    required this.title,
    required this.items,
    required this.categoryName,
    this.locationIcon,
    this.userId,
  }) : super(key: key);

  @override
  State<GenericSection> createState() => GenericSectionState();
}

class GenericSectionState extends State<GenericSection> {
  late List<DestinationModel> _filteredItems; // Ini akan menjadi salinan dari widget.items
  Map<String, bool> _favoriteStatus = {};
  Map<String, int> _likeCount = {};


  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(widget.items); // Inisialisasi dengan items yang sudah difilter
    _initializeLikeCounts();
    _loadFavoriteStatus();
  }

  void _initializeLikeCounts() {
    GenericSectionController.initializeLikeCounts(widget.items, _likeCount);
  }

  void _loadFavoriteStatus() {
    GenericSectionController.loadFavoriteStatus(
      widget.items,
      widget.userId,
      _favoriteStatus,
      setState,
    );
  }

  void _toggleFavorite(DestinationModel item) {
    GenericSectionController.toggleFavorite(
      item,
      widget.userId,
      _favoriteStatus,
      _likeCount,
      setState,
    );
  }

  @override
  void didUpdateWidget(GenericSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Hanya perlu memperbarui _filteredItems jika widget.items berubah
    // Filter dan lokasi sekarang dikelola di HomePage
    if (oldWidget.items != widget.items) {
      _filteredItems = List.from(widget.items);
      _initializeLikeCounts(); // Re-initialize like counts for new items
      _loadFavoriteStatus(); // Re-load favorite status for new items
    }
  }

  @override
  Widget build(BuildContext context) {
    // Menghapus kondisi awal ini, karena header akan selalu ditampilkan.
    // if (_filteredItems.isEmpty && !widget.title.startsWith("Hasil Pencarian untuk")) {
    //   return const SizedBox.shrink(); // Biarkan HomePage yang menampilkan empty state untuk hasil pencarian
    // }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: widget.title,
          onSeeAll: () {
            context.router.push(KatalogProdukRoute(categoryName: widget.categoryName));
          },
        ),
        SizedBox(height: 2.h), // Jaga spasi jika diperlukan

        // Items list atau empty state
        if (_filteredItems.isEmpty)
        // Menampilkan EmptyStateWidget
          EmptyStateWidget(
            title: widget.title,
            // selectedFilter dan selectedRadius diatur berdasarkan title atau nilai default
            selectedFilter: widget.title.startsWith("Hasil Pencarian untuk") ? "Search" : "Discover",
            selectedRadius: GenericSectionController.defaultRadius,
            onAdjustRadius: null, // Tombol adjust radius tidak relevan di sini lagi
          )
        else
          ItemsListWidget(
            items: _filteredItems, // Menggunakan items yang sudah difilter
            likeCount: _likeCount,
            favoriteStatus: _favoriteStatus,
            // selectedFilter tidak relevan untuk GenericSection lagi, bisa diatur statis atau sesuai kebutuhan tampilan
            selectedFilter: widget.title.startsWith("Hasil Pencarian untuk") ? "Search" : "Discover",
            userLocation: null, // Lokasi dikelola di HomePage, tidak relevan di sini untuk filtering
            locationIcon: widget.locationIcon,
            onToggleFavorite: _toggleFavorite,
          ),

        SizedBox(height: 2.h),
      ],
    );
  }
}
