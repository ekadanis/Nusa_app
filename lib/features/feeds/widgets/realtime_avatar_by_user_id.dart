import 'package:flutter/material.dart';
import '../../../services/user_profile_service.dart';
import '../../../services/google_auth_service.dart';

class RealTimeAvatarByUserId extends StatelessWidget {
  final String userId;
  final double radius;
  
  const RealTimeAvatarByUserId({
    super.key,
    required this.userId,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = GoogleAuthService.currentUser;
    final isCurrentUser = currentUser?.uid == userId;
    
    if (isCurrentUser) {
      // For current user, use existing real-time data
      return StreamBuilder<UserProfileData>(
        stream: UserProfileService.getCurrentUserProfileStream(),
        builder: (context, snapshot) {
          final userProfile = snapshot.data;
          return _buildAvatar(
            photoUrl: userProfile?.photoUrl,
            name: userProfile?.name ?? 'User',
          );
        },
      );
    } else {
      // For other users, use real-time stream by user ID
      return StreamBuilder<UserProfileData?>(
        stream: UserProfileService.getUserProfileStreamByUserId(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingAvatar();
          }
          
          final userProfile = snapshot.data;
          return _buildAvatar(
            photoUrl: userProfile?.photoUrl,
            name: userProfile?.name ?? 'User',
          );
        },
      );
    }
  }
  
  Widget _buildAvatar({String? photoUrl, required String name}) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[300],
      backgroundImage: photoUrl != null
          ? (photoUrl.startsWith('assets/')
              ? AssetImage(photoUrl) as ImageProvider
              : NetworkImage(photoUrl))
          : null,
      child: photoUrl == null
          ? Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'U',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: radius * 0.6,
              ),
            )
          : null,
    );
  }
  
  Widget _buildLoadingAvatar() {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[300],
      child: SizedBox(
        width: radius * 0.8,
        height: radius * 0.8,
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
        ),
      ),
    );
  }
}
