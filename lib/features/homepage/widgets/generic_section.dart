import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sizer/sizer.dart';
import 'package:auto_route/auto_route.dart';
import '../../../core/styles.dart';
import '../../../models/destination_model.dart';
import '../../../services/location_service.dart';
import '../../../routes/router.dart';
import 'section_header.dart';
import 'generic_section/radius_bottom_sheet.dart';
import 'generic_section/empty_state_widget.dart';
import 'generic_section/filter_chips_row.dart';
import 'generic_section/items_list_widget.dart';
import 'generic_section/generic_section_controller.dart';

class GenericSection extends StatefulWidget {
  final String title;
  final List<DestinationModel> items;
  final String categoryName;
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

  // Method to expose state for external calls
  static void refreshLocationForKey(GlobalKey<GenericSectionState> key) {
    key.currentState?._loadUserLocation();
  }
}

class GenericSectionState extends State<GenericSection> {
  String _selectedFilter = "Discover";
  late List<DestinationModel> _filteredItems;
  Map<String, bool> _favoriteStatus = {};
  Map<String, int> _likeCount = {};
  Position? _userLocation;
  bool _isLoadingLocation = false;
  double _selectedRadius = GenericSectionController.defaultRadius;

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(widget.items);
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

    if (oldWidget.items != widget.items) {
      _filteredItems = List.from(widget.items);
      _initializeLikeCounts();
      _filterItems(_selectedFilter);
    }
  }

  void _filterItems(String filter) async {
    if (filter == "Nearby" && _userLocation != null) {
      await _filterNearbyItems();
    } else {
      setState(() {
        _selectedFilter = filter;
        _filteredItems = GenericSectionController.filterItemsSync(
          widget.items,
          filter,
        );
      });
    }
  }

  Future<void> _filterNearbyItems() async {
    if (_userLocation == null) return;

    setState(() {
      _selectedFilter = "Nearby";
    });

    final nearbyItems = await GenericSectionController.filterNearbyItems(
      categoryName: widget.categoryName,
      userLocation: _userLocation!,
      radius: _selectedRadius,
    );

    setState(() {
      _filteredItems = nearbyItems;
    });
  }

  Future<void> _loadUserLocation() async {
    debugPrint('_loadUserLocation called');
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      Position? position = await LocationService.getCurrentLocation();
      debugPrint('Location result: $position');
      if (position != null && mounted) {
        setState(() {
          _userLocation = position;
        });

        debugPrint('User location set: ${position.latitude}, ${position.longitude}');

        if (_selectedFilter == "Nearby") {
          _filterItems("Nearby");
        }
      } else {
        debugPrint('Failed to get location or widget not mounted');
      }
    } catch (e) {
      debugPrint('Error loading location: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  void _showRadiusBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => RadiusBottomSheet(
        initialRadius: _selectedRadius,
        onRadiusChanged: (radius) {
          setState(() {
            _selectedRadius = radius;
          });
          if (_selectedFilter == "Nearby") {
            _filterItems("Nearby");
          }
        },
      ),
    );
  }

  Future<void> _onNearbyTapped() async {
    debugPrint('Nearby chip tapped');
    if (_userLocation == null) {
      debugPrint('User location is null, loading location...');
      await _loadUserLocation();
    }
    if (_userLocation != null) {
      debugPrint('User location available, filtering nearby items');
      _filterItems("Nearby");
      debugPrint('Filter Nearby terpilih pada ${widget.title}');
    } else {
      debugPrint('User location still null after loading');
    }
  }

  void _onFilterSelected(String filter) {
    _filterItems(filter);
    debugPrint('Filter $filter terpilih pada ${widget.title}');
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: widget.title,
          onSeeAll: () {
            context.router.push(KatalogProdukRoute(categoryName: widget.categoryName));
          },
        ),
        const SizedBox(height: Styles.xsSpacing),

        // Filter chips
        FilterChipsRow(
          selectedFilter: _selectedFilter,
          isLoadingLocation: _isLoadingLocation,
          hasUserLocation: _userLocation != null,
          selectedRadius: _selectedRadius,
          onFilterSelected: _onFilterSelected,
          onNearbyTapped: _onNearbyTapped,
          onRadiusTapped: _showRadiusBottomSheet,
        ),

        SizedBox(height: 2.h),

        // Items list or empty state
        if (_filteredItems.isEmpty)
          EmptyStateWidget(
            title: widget.title,
            selectedFilter: _selectedFilter,
            selectedRadius: _selectedRadius,
            onAdjustRadius: _selectedFilter == "Nearby" ? _showRadiusBottomSheet : null,
          )
        else
          ItemsListWidget(
            items: _filteredItems,
            likeCount: _likeCount,
            favoriteStatus: _favoriteStatus,
            selectedFilter: _selectedFilter,
            userLocation: _userLocation,
            locationIcon: widget.locationIcon,
            onToggleFavorite: _toggleFavorite,
          ),

        SizedBox(height: 2.h),
      ],
    );
  }
}
