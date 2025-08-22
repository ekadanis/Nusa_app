import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String? id;
  final String categoryName;
  final String? title;

  CategoryModel({
    this.id,
    required this.categoryName,
    this.title,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'categoryName': categoryName,
      if (title != null) 'title': title,
    };
  }

  // Create from Firestore document
  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      id: doc.id,
      categoryName: data['categoryName'] ?? '',
      title: data['title'],
    );
  }

  // Create from Map
  factory CategoryModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return CategoryModel(
      id: id,
      categoryName: map['categoryName'] ?? '',
      title: map['title'],
    );
  }

  // Copy with method
  CategoryModel copyWith({
    String? id,
    String? categoryName,
    String? title,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      categoryName: categoryName ?? this.categoryName,
      title: title ?? this.title,
    );
  }

  @override
  String toString() {
    return 'CategoryModel(id: $id, categoryName: $categoryName, title: $title)';
  }
}
