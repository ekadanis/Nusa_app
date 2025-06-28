import 'package:flutter/material.dart';
import '../../../services/user_profile_service.dart';
import '../../../services/google_auth_service.dart';

class RealTimeUserNameByUserId extends StatelessWidget {
  final String userId;
  final TextStyle? style;
  
  const RealTimeUserNameByUserId({
    super.key,
    required this.userId,
    this.style,
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
          return Text(
            userProfile?.name ?? 'User',
            style: style,
          );
        },
      );
    } else {
      // For other users, use real-time stream by user ID
      return StreamBuilder<UserProfileData?>(
        stream: UserProfileService.getUserProfileStreamByUserId(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingText();
          }
          
          final userProfile = snapshot.data;
          return Text(
            userProfile?.name ?? 'Unknown User',
            style: style,
          );
        },
      );
    }
  }
  
  Widget _buildLoadingText() {
    return Container(
      width: 80,
      height: 16,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
