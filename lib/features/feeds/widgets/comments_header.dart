import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommentsHeader extends StatelessWidget {
  final String? forumId;

  const CommentsHeader({
    super.key,
    this.forumId,
  });

  @override
  Widget build(BuildContext context) {
    if (forumId == null) {
      return const Padding(
        padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
        child: Text(
          'Comments',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('comments')
          .where('forumId', isEqualTo: forumId!)
          .snapshots(),
      builder: (context, snapshot) {
        final commentsCount = snapshot.data?.docs.length ?? 0;
        return Padding(
          padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Comments ($commentsCount)',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        );
      },
    );
  }
}
