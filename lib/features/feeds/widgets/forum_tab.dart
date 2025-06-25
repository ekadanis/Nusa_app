import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/core/services/fcm_service.dart';
import 'package:nusa_app/models/forum_model.dart';
import 'package:nusa_app/models/user_model.dart';
import 'package:nusa_app/routes/router.dart';
import 'package:nusa_app/services/firestore_service.dart';
import 'package:nusa_app/services/google_auth_service.dart';

class ForumTab extends StatelessWidget {
  const ForumTab({super.key});

  Future<UserModel?> _getUserData(String userId) async {
    try {
      return await FirestoreService.getUserById(userId);
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  // Future<void> _handleLike(ForumModel forumPost) async {
  //   if (forumPost.id == null) return;

  //   final currentUserId = GoogleAuthService.currentUserId;
  //   if (currentUserId == null) return;

  //   try {
  //     await FirestoreService.toggleForumLike(currentUserId, forumPost.id!);
  //   } catch (e) {
  //     print('Error toggling like: $e');
  //   }
  // }

  Future<void> _handleLike(ForumModel forumPost) async {
    if (forumPost.id == null) return;

    final currentUser = GoogleAuthService.currentUser;
    if (currentUser == null) return;

    final currentUserId = currentUser.uid;

    try {
      final isLiked = await FirestoreService.hasUserLikedForumPost(
          currentUserId, forumPost.id!);

      // Toggle like
      await FirestoreService.toggleForumLike(currentUserId, forumPost.id!);

      // Jika baru saja di-LIKE, kirim notifikasi
      if (!isLiked) {
        final postOwner = await FirestoreService.getUserById(forumPost.userId);
        final fcmToken = postOwner?.fcmToken;
        final postOwnerId = postOwner?.id;

        if (postOwnerId != null &&
            postOwnerId != currentUserId &&
            fcmToken != null &&
            fcmToken.isNotEmpty) {
          await FCMService.sendNotification(
            deviceToken: fcmToken,
            title: '❤️ Your post got a like!',
            body:
                '${currentUser.displayName ?? "Someone"} like your feed.',
            data: {
              'type': 'like',
              'post_id': forumPost.id!,
            },
          );
          print(
              '[✅] Notifikasi like dari ForumTab berhasil dikirim ke $postOwnerId');
        } else {
          print('[⚠️] Notifikasi TIDAK dikirim (token kosong atau user sama)');
        }
      }
    } catch (e) {
      print('❌ Error toggling like or sending notification: $e');
    }
  }

  Future<bool> _hasUserLiked(String forumId) async {
    final currentUserId = GoogleAuthService.currentUserId;
    if (currentUserId == null) return false;

    try {
      return await FirestoreService.hasUserLikedForumPost(
          currentUserId, forumId);
    } catch (e) {
      print('Error checking like status: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference myFeeds =
        FirebaseFirestore.instance.collection('feeds');

    return StreamBuilder(
      stream: myFeeds.orderBy('date', descending: true).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapShot) {
        if (streamSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (streamSnapShot.hasError) {
          print('Firestore Error: ${streamSnapShot.error}');
          return Center(
            child: Text(
              'Error: ${streamSnapShot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final docs = streamSnapShot.data?.docs ?? [];

        if (docs.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.forum_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No forum posts yet',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  'Start a discussion by creating the first post!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final forumPost = ForumModel.fromFirestore(doc);

            return _buildForumCard(context, forumPost);
          },
        );
      },
    );
  }

  Widget _buildForumCard(BuildContext context, ForumModel forumPost) {
    final dateStr =
        DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(forumPost.date);

    return InkWell(
      onTap: () => context.router.push(ForumDetailRoute(forumPost: forumPost)),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Avatar & Author & Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        FutureBuilder<UserModel?>(
                          future: _getUserData(forumPost.userId),
                          builder: (context, userSnapshot) {
                            final userName =
                                userSnapshot.data?.name ?? 'Anonymous';
                            final userInitial = userName.isNotEmpty
                                ? userName[0].toUpperCase()
                                : 'A';

                            // Check if this is the current user to get their Google photo
                            final currentUserId =
                                GoogleAuthService.currentUserId;
                            final isCurrentUser =
                                currentUserId == forumPost.userId;

                            Widget avatarWidget;

                            if (isCurrentUser) {
                              // For current user, get photo from GoogleAuthService
                              final userInfo = GoogleAuthService.getUserInfo();
                              final photoURL = userInfo['photoURL'];

                              if (photoURL != null && photoURL.isNotEmpty) {
                                avatarWidget = CircleAvatar(
                                  backgroundColor: AppColors.primary50,
                                  radius: 20,
                                  backgroundImage: NetworkImage(photoURL),
                                  onBackgroundImageError: (_, __) {
                                    // Fallback to initial if image fails to load
                                  },
                                  child: photoURL.isEmpty
                                      ? Text(
                                          userInitial,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : null,
                                );
                              } else {
                                avatarWidget = CircleAvatar(
                                  backgroundColor: AppColors.primary50,
                                  radius: 20,
                                  child: Text(
                                    userInitial,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              }
                            } else {
                              // For other users, use their stored photoURL if available
                              final photoURL = userSnapshot.data?.photoURL;

                              if (photoURL != null && photoURL.isNotEmpty) {
                                avatarWidget = CircleAvatar(
                                  backgroundColor: AppColors.primary50,
                                  radius: 20,
                                  backgroundImage: NetworkImage(photoURL),
                                  onBackgroundImageError: (_, __) {
                                    // Fallback to initial if image fails to load
                                  },
                                  child: photoURL.isEmpty
                                      ? Text(
                                          userInitial,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : null,
                                );
                              } else {
                                avatarWidget = CircleAvatar(
                                  backgroundColor: AppColors.primary50,
                                  radius: 20,
                                  child: Text(
                                    userInitial,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              }
                            }

                            return avatarWidget;
                          },
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder<UserModel?>(
                                future: _getUserData(forumPost.userId),
                                builder: (context, userSnapshot) {
                                  if (userSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Text(
                                      'Loading...',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    );
                                  }

                                  final userName = userSnapshot.data?.name ??
                                      'Anonymous User';
                                  return Text(
                                    userName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  );
                                },
                              ),
                              Text(
                                dateStr,
                                style: TextStyle(
                                  color: AppColors.grey300,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Content
              Text(
                forumPost.content,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 16),

              // Likes & Comments Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      FutureBuilder<bool>(
                        future: forumPost.id != null
                            ? _hasUserLiked(forumPost.id!)
                            : Future.value(false),
                        builder: (context, likeSnapshot) {
                          final isLiked = likeSnapshot.data ?? false;

                          return GestureDetector(
                            onTap: () => _handleLike(forumPost),
                            child: Row(
                              children: [
                                Icon(
                                  isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isLiked
                                      ? Colors.red
                                      : AppColors.primary50,
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${forumPost.like}',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          // Navigate to forum detail for comments
                          context.router
                              .push(ForumDetailRoute(forumPost: forumPost));
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.comment_outlined,
                              color: AppColors.primary50,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${forumPost.commentsCount}',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => context.router
                        .push(ForumDetailRoute(forumPost: forumPost)),
                    child: const Row(
                      children: [
                        Text(
                          'View More',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.blue,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
