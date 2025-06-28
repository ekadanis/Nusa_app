import 'package:flutter/material.dart';
import '../../../services/user_profile_service.dart';
import '../../../services/google_auth_service.dart';

class RealTimeUserInfo extends StatelessWidget {
  final String userId;
  final DateTime date;
  
  const RealTimeUserInfo({
    super.key,
    required this.userId,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = GoogleAuthService.currentUser;
    final isCurrentUser = currentUser?.uid == userId;
    
    if (isCurrentUser) {
      // For current user, use real-time data from UserProfileService
      return StreamBuilder<UserProfileData>(
        stream: UserProfileService.getCurrentUserProfileStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingUserInfo();
          }
          
          final userProfile = snapshot.data;
          return _buildUserInfo(
            name: userProfile?.name ?? 'User',
            photoUrl: userProfile?.photoUrl,
            date: date,
          );
        },
      );
    } else {
      // For other users, use real-time stream by user ID
      return StreamBuilder<UserProfileData?>(
        stream: UserProfileService.getUserProfileStreamByUserId(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingUserInfo();
          }
          
          final userProfile = snapshot.data;
          if (userProfile == null) {
            return _buildUserInfo(
              name: 'Unknown User',
              photoUrl: null,
              date: date,
            );
          }
          
          return _buildUserInfo(
            name: userProfile.name,
            photoUrl: userProfile.photoUrl,
            date: date,
          );
        },
      );
    }
  }
  
  Widget _buildLoadingUserInfo() {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: Colors.grey[300],
          child: const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatDate(date),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUserInfo({
    required String name,
    String? photoUrl,
    required DateTime date,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: Colors.grey[300],
          backgroundImage: photoUrl != null
              ? (photoUrl.startsWith('assets/')
                  ? AssetImage(photoUrl) as ImageProvider
                  : NetworkImage(photoUrl))
              : null,
          child: photoUrl == null
              ? Text(
                  name.isNotEmpty ? name[0].toUpperCase() : 'U',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              : null,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              _formatDate(date),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
