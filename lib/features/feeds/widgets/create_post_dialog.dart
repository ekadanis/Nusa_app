import 'package:flutter/material.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/features/feeds/services/feed_service.dart';
import 'package:nusa_app/features/inbox/services/inbox_notification_services.dart';
import 'package:nusa_app/models/forum_model.dart';
import 'package:nusa_app/services/google_auth_service.dart';

class CreatePostDialog extends StatefulWidget {
  const CreatePostDialog({super.key});

  @override
  State<CreatePostDialog> createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends State<CreatePostDialog> {
  final TextEditingController _postController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _postController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  Future<void> _createPost() async {
    final content = _postController.text.trim();

    if (content.isEmpty) {
      _showMessage('Message cannot be empty', isError: true);
      return;
    }

    final currentUserId = GoogleAuthService.currentUserId;
    if (currentUserId == null) {
      _showMessage('Please login first to create a post', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final forumPost = ForumModel(
        content: content,
        date: DateTime.now(),
        userId: currentUserId,
        like: 0,
        commentsCount: 0,
      );

      await FeedService.createFeedPost(
        forumPost: forumPost,
        currentUserId: currentUserId,
      );

      if (!mounted) return;
      Navigator.of(context).pop();
      _showMessage('Post created successfully!');
    } catch (e) {
      _showMessage('Error: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final contentLength = _postController.text.length;
    final isContentValid = contentLength > 0 && contentLength <= 500;

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
          maxWidth: MediaQuery.of(context).size.width - 32,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Share Message to Forum!',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary50,
                          ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey, size: 24),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Text Input
              Container(
                constraints:
                    const BoxConstraints(minHeight: 120, maxHeight: 200),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.grey200, width: 1.5),
                ),
                child: TextField(
                  controller: _postController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText:
                        'Write your message here...\n\nShare your thoughts, questions, or cultural experiences!',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                    hintStyle: TextStyle(
                        fontSize: 14, color: AppColors.grey500, height: 1.5),
                  ),
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
              ),

              const SizedBox(height: 16),

              // Character Counter
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$contentLength/500',
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          contentLength > 500 ? Colors.red : AppColors.grey500,
                    ),
                  ),
                  if (contentLength > 500)
                    const Text(
                      'Message too long',
                      style: TextStyle(fontSize: 12, color: Colors.red),
                    ),
                ],
              ),

              const SizedBox(height: 20),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed:
                          _isLoading ? null : () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.grey200),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            color: AppColors.grey500,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          _isLoading || !isContentValid ? null : _createPost,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary50,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 2,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Share',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
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
