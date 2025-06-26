import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nusa_app/core/services/fcm_service.dart';
import 'package:nusa_app/features/feeds/services/comment_service.dart';
import '../../../models/models.dart';
import '../../../services/firestore_service.dart';
import '../../../services/google_auth_service.dart';
import '../widgets/forum_app_bar.dart';
import '../widgets/forum_post_content.dart';
import '../widgets/comments_header.dart';
import '../widgets/comments_list.dart';
import '../widgets/comment_input.dart';

@RoutePage()
class ForumDetailPage extends StatefulWidget {
  final ForumModel forumPost;

  const ForumDetailPage({
    super.key,
    required this.forumPost,
  });

  @override
  State<ForumDetailPage> createState() => _ForumDetailPageState();
}

class _ForumDetailPageState extends State<ForumDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  bool _isAddingComment = false;
  bool _isLiked = false;
  int _likeCount = 0;
  UserModel? _postAuthor;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.forumPost.like;
    _loadPostAuthor();
    _checkIfLiked();
  }

  Future<void> _loadPostAuthor() async {
    final author = await FirestoreService.getUserById(widget.forumPost.userId);
    if (mounted) {
      setState(() {
        _postAuthor = author;
      });
    }
  }

  Future<void> _checkIfLiked() async {
    final currentUser = GoogleAuthService.currentUser;
    if (currentUser != null && widget.forumPost.id != null) {
      final isLiked = await FirestoreService.hasUserLikedForumPost(
        currentUser.uid,
        widget.forumPost.id!,
      );
      if (mounted) {
        setState(() {
          _isLiked = isLiked;
        });
      }
    }
  }

  Future<void> _toggleLike() async {
    final currentUser = GoogleAuthService.currentUser;
    if (currentUser == null || widget.forumPost.id == null) return;

    final oldIsLiked = _isLiked;

    setState(() {
      if (_isLiked) {
        _likeCount--;
        _isLiked = false;
      } else {
        _likeCount++;
        _isLiked = true;
      }
    });

    try {
      await FirestoreService.toggleForumLike(
        currentUser.uid,
        widget.forumPost.id!,
      );

      if (!oldIsLiked) {
        // artinya baru saja di-LIKE (bukan unlike)
        final postOwner =
            await FirestoreService.getUserById(widget.forumPost.userId);
        final fcmToken = postOwner?.fcmToken;
        final postOwnerId = postOwner?.id;

        print('Like Notification Debug');
        print(' Post Owner ID: $postOwnerId');
        print(' Current User ID: ${currentUser.uid}');
        print(' FCM Token: $fcmToken');

        final title = '❤️ New Like!';
        final message =
            '${currentUser.displayName ?? "Someone"} like your feed.';

        if (postOwnerId != null &&
            postOwnerId != currentUser.uid &&
            fcmToken != null &&
            fcmToken.isNotEmpty) {
          await FCMService.sendNotification(
            deviceToken: fcmToken,
            title: title,
            body: message,
            data: {
              'type': 'like',
              'post_id': widget.forumPost.id!,
            },
          );

          print('Notifikasi FCM like berhasil dikirim ke $postOwnerId');

          final likeComment = await FirebaseFirestore.instance
              .collection('inbox_notification')
              .doc(postOwnerId)
              .collection('items')
              .add({
            'title': title,
            'message': message,
            'postId': widget.forumPost.id!,
            'type': 'comment',
            'updateAt': FieldValue.serverTimestamp(),
          });
          print(
              'INBOX Notifikasi like berhasil dikirim ke $postOwnerId, dengan like comment id $likeComment');
        } else {
          print(
              ' Notifikasi like TIDAK dikirim. Penyebab mungkin: token kosong, sama user, atau null');
        }
      }
    } catch (e) {
      // Revert on error
      if (mounted) {
        setState(() {
          if (_isLiked) {
            _likeCount--;
            _isLiked = false;
          } else {
            _likeCount++;
            _isLiked = true;
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ForumAppBar(
        userId: widget.forumPost.userId,
        date: widget.forumPost.date,
        postAuthor: _postAuthor,
      ),
      body: Column(
        children: [
          ForumPostContent(
            forumPost: widget.forumPost,
            isLiked: _isLiked,
            likeCount: _likeCount,
            onToggleLike: _toggleLike,
          ),
          const Divider(),
          CommentsHeader(forumId: widget.forumPost.id),
          Expanded(
            child: CommentsList(forumId: widget.forumPost.id),
          ),
          CommentInput(
            controller: _commentController,
            isLoading: _isAddingComment,
            onAddComment: () => commentService(
              controller: _commentController,
              forumPost: widget.forumPost,
              context: context,
              onStart: () => setState(() => _isAddingComment = true),
              onComplete: () => setState(() => _isAddingComment = false),
            ),
          ),
        ],
      ),
    );
  }
}
