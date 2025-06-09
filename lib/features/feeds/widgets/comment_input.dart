import 'package:flutter/material.dart';
import '../../../models/models.dart';
import '../../../services/firestore_service.dart';
import '../../../services/google_auth_service.dart';
import 'user_avatar_widget.dart';

class CommentInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onAddComment;

  const CommentInput({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.onAddComment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [          FutureBuilder<UserModel?>(
            future: GoogleAuthService.currentUser != null
                ? FirestoreService.getUserById(GoogleAuthService.currentUser!.uid)
                : Future.value(null),
            builder: (context, snapshot) {
              final user = snapshot.data;
              return UserAvatarWidget(
                user: user, 
                radius: 16,
                userId: GoogleAuthService.currentUserId,
              );
            },
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Type your message here...',
                  hintStyle: TextStyle(fontSize: 14),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: isLoading ? null : onAddComment,
            child: Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                color: isLoading ? Colors.grey : Colors.blue,
                borderRadius: BorderRadius.circular(18),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
