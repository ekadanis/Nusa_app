import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String? id;
  final String content;
  final DateTime date;
  final String userId;
  final String forumId;

  CommentModel({
    this.id,
    required this.content,
    required this.date,
    required this.userId,
    required this.forumId,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'content': content,
      'date': Timestamp.fromDate(date),
      'userId': userId,
      'forumId': forumId,
    };
  }

  // Create from Firestore document
  factory CommentModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CommentModel(
      id: doc.id,
      content: data['content'] ?? '',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      userId: data['userId'] ?? '',
      forumId: data['forumId'] ?? '',
    );
  }

  // Create from Map
  factory CommentModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return CommentModel(
      id: id,
      content: map['content'] ?? '',
      date: map['date'] is Timestamp 
          ? (map['date'] as Timestamp).toDate() 
          : map['date'] ?? DateTime.now(),
      userId: map['userId'] ?? '',
      forumId: map['forumId'] ?? '',
    );
  }

  // Copy with method
  CommentModel copyWith({
    String? id,
    String? content,
    DateTime? date,
    String? userId,
    String? forumId,
  }) {
    return CommentModel(
      id: id ?? this.id,
      content: content ?? this.content,
      date: date ?? this.date,
      userId: userId ?? this.userId,
      forumId: forumId ?? this.forumId,
    );
  }
}
