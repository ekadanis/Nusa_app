import 'package:flutter/material.dart';
import '../../../models/models.dart';

class ForumPostContent extends StatelessWidget {
  final ForumModel forumPost;
  final bool isLiked;
  final int likeCount;
  final VoidCallback onToggleLike;

  const ForumPostContent({
    super.key,
    required this.forumPost,
    required this.isLiked,
    required this.likeCount,
    required this.onToggleLike,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            forumPost.content,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              LikeButton(
                isLiked: isLiked,
                likeCount: likeCount,
                onTap: onToggleLike,
              ),
              const SizedBox(width: 16),
              CommentCount(commentsCount: forumPost.commentsCount),
            ],
          ),
        ],
      ),
    );
  }
}

class LikeButton extends StatelessWidget {
  final bool isLiked;
  final int likeCount;
  final VoidCallback onTap;

  const LikeButton({
    super.key,
    required this.isLiked,
    required this.likeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.red : Colors.blue,
            size: 18,
          ),
          const SizedBox(width: 4),
          Text(
            _formatCount(likeCount),
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    } else {
      return count.toString();
    }
  }
}

class CommentCount extends StatelessWidget {
  final int commentsCount;

  const CommentCount({
    super.key,
    required this.commentsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.comment_outlined, color: Colors.blue, size: 18),
        const SizedBox(width: 4),
        Text(
          '$commentsCount',
          style: const TextStyle(fontSize: 13),
        ),
      ],
    );
  }
}
