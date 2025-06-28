import 'package:flutter/material.dart';
import '../../../services/user_profile_service.dart';

class RealTimeAvatar extends StatelessWidget {
  final double radius;
  
  const RealTimeAvatar({
    super.key,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserProfileData>(
      stream: UserProfileService.getCurrentUserProfileStream(),
      builder: (context, snapshot) {
        final userProfile = snapshot.data;
        final photoUrl = userProfile?.photoUrl;
        final name = userProfile?.name ?? 'User';
        
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
      },
    );
  }
}
