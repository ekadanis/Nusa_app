import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/app_colors.dart';
import '../../../core/styles.dart';
import '../../../services/user_profile_service.dart';
import '../../../routes/router.dart';
import '../../../services/google_auth_service.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserProfileData>(
      stream: UserProfileService.getCurrentUserProfileStream(),
      builder: (context, snapshot) {
        final userProfile = snapshot.data;
        final isLoading = snapshot.connectionState == ConnectionState.waiting;

        return Container(
          height: 16.h,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Background container with extended height
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom:
                    -30, // Extend the background down to cover rounded corners
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary50,
                    image: DecorationImage(
                      image: const AssetImage('assets/banner/banner.png'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        AppColors.primary50,
                        BlendMode.multiply,
                      ),
                    ),
                  ),
                ),
              ),
              // Content container
              Container(
                height: 16.h,
                width: 100.w,
                padding: EdgeInsets.symmetric(
                  horizontal: Styles.mdPadding,
                  vertical: 1.5.h,
                ),
                child: Align(
                  alignment: Alignment(0, 0.3), // sedikit di atas bottom
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildAvatar(userProfile),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: _buildUserInfo(context, userProfile, isLoading),
                      ),
                      _buildNotificationButton(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAvatar(UserProfileData? userProfile) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: userProfile?.photoUrl != null
          ? (userProfile!.photoUrl!.startsWith('assets/')
              ? Image.asset(
                  userProfile.photoUrl!,
                  width: 12.w,
                  height: 12.w,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  userProfile.photoUrl!,
                  width: 12.w,
                  height: 12.w,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/avatar/avatar-1.jpg',
                      width: 12.w,
                      height: 12.w,
                      fit: BoxFit.cover,
                    );
                  },
                ))
          : Image.asset(
              'assets/avatar/avatar-1.jpg',
              width: 12.w,
              height: 12.w,
              fit: BoxFit.cover,
            ),
    );
  }

  Widget _buildUserInfo(
      BuildContext context, UserProfileData? userProfile, bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        isLoading
            ? Container(
                width: 30.w,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              )
            : Text(
                "${userProfile?.name ?? 'User'} !",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
        SizedBox(height: 0.5.h),
        Row(
          children: [
            Text(
              "Welcome Back",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(width: 1.w),
            const Text("👋", style: TextStyle(fontSize: 14)),
          ],
        ),
      ],
    );
  }

  Widget _buildNotificationButton(BuildContext context) {
    final currentUser = GoogleAuthService.currentUser;
    if (currentUser == null) {
      return _buildNotificationIcon(context, false);
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('notifications')
          .doc(currentUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
        bool hasUnreadNotifications = false;

        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>?;
          // Cek jika field unreadCount ada dan bertipe int
          final unreadCount = (data != null && data['unreadCount'] is int)
              ? data['unreadCount'] as int
              : 0;
          hasUnreadNotifications = unreadCount > 0;
        }

        return _buildNotificationIcon(context, hasUnreadNotifications);
      },
    );
  }

  Widget _buildNotificationIcon(BuildContext context, bool hasUnread) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      padding: EdgeInsets.all(2.w),
      child: GestureDetector(
        onTap: () async {
          // Navigate to inbox
          await context.router.push(const InboxRoute());

          // Mark notifications as read
          final currentUser = GoogleAuthService.currentUser;
          if (currentUser != null) {
            await _markNotificationsAsRead(currentUser.uid);
          }
        },
        child: Stack(
          children: [
            Icon(
              IconsaxPlusBold.notification,
              color: Colors.white,
              size: 6.w,
            ),
            if (hasUnread)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _markNotificationsAsRead(String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(userId)
          .update({
        'unreadCount': 0, // Set ke 0 saat sudah dibaca
        'lastReadTime': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Handle error silently or log if needed
      print('Error marking notifications as read: $e');
    }
  }
}
