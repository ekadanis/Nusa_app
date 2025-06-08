import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleModel {
  final String? id;
  final String title;
  final DateTime date;
  final String categoryId;
  final String content;
  final String imageUrl;
  final int like; // total like count

  ArticleModel({
    this.id,
    required this.title,
    required this.date,
    required this.categoryId,
    required this.content,
    required this.imageUrl,
    this.like = 0,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'date': Timestamp.fromDate(date),
      'categoryId': categoryId,
      'content': content,
      'imageUrl': imageUrl,
      'like': like,
    };
  }

  // Create from Firestore document
  factory ArticleModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ArticleModel(
      id: doc.id,
      title: data['title'] ?? '',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      categoryId: data['categoryId'] ?? '',
      content: data['content'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      like: data['like'] ?? 0,
    );
  }

  // Create from Map
  factory ArticleModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return ArticleModel(
      id: id,
      title: map['title'] ?? '',
      date: map['date'] is Timestamp 
          ? (map['date'] as Timestamp).toDate() 
          : map['date'] ?? DateTime.now(),
      categoryId: map['categoryId'] ?? '',
      content: map['content'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      like: map['like'] ?? 0,
    );
  }

  // Copy with method
  ArticleModel copyWith({
    String? id,
    String? title,
    DateTime? date,
    String? categoryId,
    String? content,
    String? imageUrl,
    int? like,
  }) {
    return ArticleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      categoryId: categoryId ?? this.categoryId,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      like: like ?? this.like,
    );
  }

  @override
  String toString() {
    return 'ArticleModel(id: $id, title: $title, categoryId: $categoryId, like: $like)';
  }
}
