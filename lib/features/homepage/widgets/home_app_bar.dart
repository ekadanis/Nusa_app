
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/styles.dart';
import '../../../../models/models.dart';
import '../../../../services/google_auth_service.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  UserModel? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }
  Future<void> _fetchUserData() async {
    try {
      // Dapatkan user ID yang sudah terotentikasi
      final currentUser = GoogleAuthService.currentUser;
      if (currentUser == null) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        return;
      }

      final userId = currentUser.uid;      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists && mounted) {
        final user = UserModel.fromFirestore(userDoc);
        
        // Check if user profile needs photo update from Google
        if (user.photoURL == null && currentUser.photoURL != null) {
          // Refresh user profile with Google data
          await GoogleAuthService.refreshCurrentUserProfile();
          // Fetch updated user data
          final updatedDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();
          if (updatedDoc.exists) {
            setState(() {
              _currentUser = UserModel.fromFirestore(updatedDoc);
              _isLoading = false;
            });
          }
        } else {
          setState(() {
            _currentUser = user;
            _isLoading = false;
          });
        }} else {
        // Buat profil user jika belum ada menggunakan GoogleAuthService
        await GoogleAuthService.createOrUpdateUserProfile(currentUser);
        // Fetch the created user data
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        if (userDoc.exists && mounted) {
          setState(() {
            _currentUser = UserModel.fromFirestore(userDoc);
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 20.h,
            width: 100.w,
            padding: EdgeInsets.symmetric(
              horizontal: Styles.mdPadding,
              vertical: 2.h,
            ),
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
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          'assets/avatar/avatar-1.png',
                          width: 12.w,
                          height: 12.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _isLoading
                                ? Container(
                                    width: 30.w,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  )
                                : Text(
                                    "${_currentUser?.name ?? 'Zhafran Arise'} !",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Colors.white.withValues(alpha: 0.8),
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(width: 1.w),
                                const Text("👋", style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(2.w),
                        child: Icon(
                          IconsaxPlusBold.notification,
                          color: Colors.white,
                          size: 6.w,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3.h),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: 100.w,
              height: 4.h,
              clipBehavior: Clip.antiAlias,
              decoration: const ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Styles.lgRadius),
                    topRight: Radius.circular(Styles.lgRadius),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeAppBarStateless extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBarStateless({Key? key}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(22.h);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 20.h,
            width: 100.w,
            padding: EdgeInsets.symmetric(
              horizontal: Styles.mdPadding,
              vertical: 2.h,
            ),
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
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          'assets/avatar/avatar-1.png',
                          width: 12.w,
                          height: 12.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Zhafran Arise !",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color:
                                            Colors.white.withValues(alpha: 0.8),
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(width: 1.w),
                                const Text("👋",
                                    style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(2.w),
                        child: Icon(
                          IconsaxPlusBold.notification,
                          color: Colors.white,
                          size: 6.w,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3.h),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: 100.w,
              height: 4.h,
              clipBehavior: Clip.antiAlias,
              decoration: const ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Styles.lgRadius),
                    topRight: Radius.circular(Styles.lgRadius),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
