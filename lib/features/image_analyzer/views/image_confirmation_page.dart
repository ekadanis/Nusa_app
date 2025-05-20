import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/routes/router.dart';
import 'package:nusa_app/util/extensions.dart';
import 'package:nusa_app/widgets/custom_button.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

@RoutePage()
class ImageConfirmationPage extends StatefulWidget {
  final XFile pickedImage;
  const ImageConfirmationPage({super.key, required this.pickedImage});

  @override
  State<ImageConfirmationPage> createState() => _ImageConfirmationPageState();
}

class _ImageConfirmationPageState extends State<ImageConfirmationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.file(
              File(widget.pickedImage.path),
              fit: BoxFit.cover,
            ),
          ),
          SlideTransition(
            position: _slideAnimation,
            child: Container(
              width: double.infinity,
              height: 172,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  SizedBox(height: 24),
                  Text('Analyze this picture?',
                      style: context.textTheme.titleMedium),
                  SizedBox(height: 36),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: CustomButton(
                            buttonText: 'Discard',
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            isOutlinedButton: true,
                            borderColor: AppColors.danger50,
                            fontSize: 14,
                            textColor: AppColors.danger50,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: CustomButton(
                            buttonText: 'Analyze Now',
                            suffixIcon: IconsaxPlusLinear.search_normal_1,
                            onPressed: () {
                              AutoRouter.of(context).push(
                                  ImageResultRoute(image: widget.pickedImage));
                            },
                            backgroundColor: AppColors.primary50,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
