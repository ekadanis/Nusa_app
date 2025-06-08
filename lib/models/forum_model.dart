import 'package:cloud_firestore/cloud_firestore.dart';

class ForumModel {
  final String? id;
  final String content;
  final DateTime date;
  final int like;
  final String userId;

  ForumModel({
    this.id,
    required this.content,
    required this.date,
    required this.userId,
    this.like = 0,
  });
  // Convert to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'content': content,
      'date': Timestamp.fromDate(date),
      'like': like,
      'userId': userId,
    };
  }
  // Create from Firestore document
  factory ForumModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ForumModel(
      id: doc.id,
      content: data['content'] ?? '',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      like: data['like'] ?? 0,
      userId: data['userId'] ?? '',
    );
  }
  // Create from Map
  factory ForumModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return ForumModel(
      id: id,
      content: map['content'] ?? '',
      date: map['date'] is Timestamp 
          ? (map['date'] as Timestamp).toDate() 
          : map['date'] ?? DateTime.now(),
      like: map['like'] ?? 0,
      userId: map['userId'] ?? '',
    );
  }
  // Copy with method
  ForumModel copyWith({
    String? id,
    String? content,
    DateTime? date,
    int? like,
    String? userId,
  }) {
    return ForumModel(
      id: id ?? this.id,
      content: content ?? this.content,
      date: date ?? this.date,
      like: like ?? this.like,
      userId: userId ?? this.userId,
    );
  }

  @override
  String toString() {
    return 'ForumModel(id: $id, content: ${content.length > 50 ? content.substring(0, 50) + "..." : content}, like: $like)';
  }
}
