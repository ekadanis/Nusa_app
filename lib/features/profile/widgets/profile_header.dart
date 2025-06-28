import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_colors.dart';
import '../../../services/user_profile_service.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfileData userProfile;
  final VoidCallback? onEditPressed;

  const ProfileHeader({
    super.key,
    required this.userProfile,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          // Profile Avatar
          Stack(
            children: [
              CircleAvatar(
                radius: 15.w,
                backgroundColor: Colors.white.withOpacity(0.3),
                backgroundImage: userProfile.photoUrl != null
                    ? (userProfile.photoUrl!.startsWith('assets/') 
                        ? AssetImage(userProfile.photoUrl!) as ImageProvider
                        : NetworkImage(userProfile.photoUrl!))
                    : null,
                child: userProfile.photoUrl == null
                    ? Text(
                        userProfile.name.isNotEmpty
                            ? userProfile.name.substring(0, 1).toUpperCase()
                            : 'U',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onEditPressed,
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      IconsaxPlusLinear.edit,
                      size: 4.w,
                      color: AppColors.grey50,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // User Info
          Text(
            userProfile.name.isNotEmpty ? userProfile.name : 'User',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
          Text(
            userProfile.email.isNotEmpty ? userProfile.email : 'No email',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                ),
          ),
        ],
      ),
    );
  }
}
