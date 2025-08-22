import 'dart:convert';
import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/features/image_analyzer/service/image_service.dart';
import 'package:nusa_app/util/extensions.dart';
import 'package:nusa_app/widgets/loading_screen.dart';
import '../model/image_object.dart';
import '../widgets/image_result_header.dart';
import '../widgets/image_result_overview.dart';
import '../widgets/image_result_content.dart';

@RoutePage()
class ImageResultPage extends StatefulWidget {
  final File image;
  const ImageResultPage({super.key, required this.image});

  @override
  State<ImageResultPage> createState() => _ImageResultPageState();
}

class _ImageResultPageState extends State<ImageResultPage> {
  late Future<ImageObject?> _budaya;

  @override
  void initState() {
    super.initState();
    _budaya = analyzeAndParse(widget.image);
  }

  Future<ImageObject?> analyzeAndParse(File image) async {
    final response;
    try {
      response = await analyzeImage(context, image);
    } catch (e) {
      if (mounted) {
        AutoRouter.of(context).maybePop({'isNotValid': true});
      }
      return null;
    }
    final regex = RegExp(r'```json\n(.*?)\n```', dotAll: true);
    final match = regex.firstMatch(response);

    if (match != null) {
      final jsonStr = match.group(1);
      if (jsonStr != null) {
        final jsonMap = jsonDecode(jsonStr);
        return ImageObject.fromJson(jsonMap);
      }
    }

    return null;
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ImageObject?>(
      future: _budaya,
      builder: (context, snapshot) {        // Show loading screen while analyzing
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        }

        // Show error if analysis failed or data is null
        if (snapshot.hasError || snapshot.data == null) {
          return Scaffold(
            backgroundColor: AppColors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 20.w,
                    color: AppColors.danger50,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Failed to analyze image',
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 1.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Text(
                      'The image could not be analyzed or the cultural object was not recognized.',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: AppColors.grey50,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final budaya = snapshot.data!;
        
        return Scaffold(
          backgroundColor: AppColors.white,
          body: ListView(
            children: [
              // Header with image and culture name
              ImageResultHeader(
                image: widget.image,
                cultureName: budaya.namaBudaya,
              ),

              SizedBox(height: 3.h),

              // Overview section with description and origin badge
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: ImageResultOverview(
                  description: budaya.deskripsiSingkat,
                  origin: budaya.asalDaerah,
                ),
              ),

              SizedBox(height: 3.h),

              // All expandable content sections
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: ImageResultContent(imageObject: budaya),
              ),

              SizedBox(height: 3.h),
            ],
          ),
        );
      },
    );
  }
}
