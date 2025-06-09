import 'package:flutter/material.dart';
import '../../../models/models.dart';
import '../../../services/google_auth_service.dart';

class UserAvatarWidget extends StatelessWidget {
  final UserModel? user;
  final double radius;
  final String? userId; // ID user untuk dicek apakah current user

  const UserAvatarWidget({
    super.key,
    this.user,
    required this.radius,
    this.userId,
  });  @override
  Widget build(BuildContext context) {
    // Cek apakah ini adalah user yang sedang login
    final currentUserId = GoogleAuthService.currentUserId;
    
    // Cek dengan userId parameter atau user.id
    final targetUserId = userId ?? user?.id;
    final isCurrentUser = currentUserId != null && targetUserId == currentUserId;
    
    String? photoURL;
    
    if (isCurrentUser) {
      // Untuk current user, ambil foto dari GoogleAuthService
      final userInfo = GoogleAuthService.getUserInfo();
      photoURL = userInfo['photoURL'];
    } else {
      // Untuk user lain, gunakan photoURL dari Firestore
      photoURL = user?.photoURL;
    }
    
    // Jika ada photoURL (foto Google), gunakan itu
    if (photoURL != null && photoURL.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(photoURL),
        backgroundColor: Colors.transparent,
        // Fallback jika gambar gagal dimuat
        onBackgroundImageError: (exception, stackTrace) {
          debugPrint('Failed to load profile image: $exception');
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey.withOpacity(0.3),
              width: 0.5,
            ),
          ),
        ),
      );
    }
    
    // Fallback ke initial huruf pertama nama
    return CircleAvatar(
      radius: radius,
      backgroundColor: _getAvatarColor(user?.name),
      child: Text(
        _getInitials(user?.name),
        style: TextStyle(
          color: Colors.white,
          fontSize: radius * 0.8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return 'U';
    
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  Color _getAvatarColor(String? name) {
    // Generate warna berdasarkan nama untuk konsistensi
    if (name == null || name.isEmpty) return Colors.blue;
    
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
    ];
    
    final hash = name.hashCode.abs();
    return colors[hash % colors.length];
  }
}
