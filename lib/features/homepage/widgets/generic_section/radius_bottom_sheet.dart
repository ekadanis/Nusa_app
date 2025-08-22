import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/app_colors.dart';

class RadiusBottomSheet extends StatefulWidget {
  final double initialRadius;
  final Function(double) onRadiusChanged;

  const RadiusBottomSheet({
    Key? key,
    required this.initialRadius,
    required this.onRadiusChanged,
  }) : super(key: key);

  @override
  State<RadiusBottomSheet> createState() => _RadiusBottomSheetState();
}

class _RadiusBottomSheetState extends State<RadiusBottomSheet> {
  late double _selectedRadius;

  @override
  void initState() {
    super.initState();
    _selectedRadius = widget.initialRadius;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      height: 45.h,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header@
          Text(
            'Select Search Radius',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
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
          SizedBox(height: 2.h),
          // Quick preset buttons
          Text(
            'Quick Presets',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.grey60,
                ),
          ),
          SizedBox(height: 1.h),

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
              SizedBox(width: 2.w),
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
