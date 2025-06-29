import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../../core/app_colors.dart';

class RadiusBottomSheet extends StatefulWidget {
  final double initialRadius;
  final Function(double) onRadiusChanged;
  final VoidCallback? onRefreshLocation;

  const RadiusBottomSheet({
    Key? key,
    required this.initialRadius,
    required this.onRadiusChanged,
    this.onRefreshLocation,
  }) : super(key: key);

  @override
  State<RadiusBottomSheet> createState() => _RadiusBottomSheetState();
}

class _RadiusBottomSheetState extends State<RadiusBottomSheet> {
  late double _selectedRadius;
  bool _isRefreshingLocation = false;

  @override
  void initState() {
    super.initState();
    _selectedRadius = widget.initialRadius;
  }

  Future<void> _refreshLocation() async {
    if (widget.onRefreshLocation == null) return;

    setState(() {
      _isRefreshingLocation = true;
    });

    try {
      await Future.delayed(Duration(milliseconds: 500)); // Simulate loading
      widget.onRefreshLocation!();

      // Show success feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  IconsaxPlusBold.tick_circle,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text('Location updated successfully'),
              ],
            ),
            backgroundColor: AppColors.success50,
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      // Show error feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  IconsaxPlusBold.close_circle,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text('Failed to update location'),
              ],
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshingLocation = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      height: 50.h, // Increased height to accommodate new button
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with refresh location button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Select Search Radius',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (widget.onRefreshLocation != null)
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary50.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: _isRefreshingLocation ? null : _refreshLocation,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 1.h,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedSwitcher(
                              duration: Duration(milliseconds: 200),
                              child: _isRefreshingLocation
                                  ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primary50,
                                  ),
                                ),
                              )
                                  : Icon(
                                IconsaxPlusBold.location,
                                color: AppColors.primary50,
                                size: 16,
                              ),
                            ),
                            // SizedBox(width: 1.w),
                            Text(
                              _isRefreshingLocation ? 'Updating...' : 'Refresh',
                              style: TextStyle(
                                color: AppColors.primary50,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 2.h),

          // Current radius display
          Text(
            '${_selectedRadius.round()} km',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.primary50,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 1.h),

          // Slider
          Slider(
            value: _selectedRadius,
            min: 5,
            max: 1000,
            divisions: 199,
            activeColor: AppColors.primary50,
            label: '${_selectedRadius.round()} km',
            onChanged: (value) {
              setState(() {
                _selectedRadius = value;
              });
            },
          ),
          //SizedBox(height: 2.h),

          // Quick preset buttons
          Text(
            'Quick Presets',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.grey60,
            ),
          ),
          //SizedBox(height: 1.h),

          // Preset chips
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: [50, 100, 250, 500, 1000].map((radius) {
              return ChoiceChip(
                label: Text('${radius}km'),
                selected: _selectedRadius == radius.toDouble(),
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedRadius = radius.toDouble();
                    });
                  }
                },
                selectedColor: AppColors.primary50,
                backgroundColor: AppColors.grey10,
                labelStyle: TextStyle(
                  color: _selectedRadius == radius.toDouble()
                      ? Colors.white
                      : AppColors.grey70,
                ),
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
              );
            }).toList(),
          ),

          SizedBox(height: 3.h),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  ),
                  child: Text(
                    'Cancel',
                  ),
                ),
              ),
              // SizedBox(width: 1.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onRadiusChanged(_selectedRadius);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary50,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  ),
                  child: Text(
                    'Apply',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}