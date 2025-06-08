import 'package:cloud_firestore/cloud_firestore.dart';

class DestinationModel {
  final String? id;
  final String categoryId;
  final String subcategory;
  final String imageUrl;
  final GeoPoint location;
  final String address;
  final String title;
  final int like;
  final int recommendation;

  DestinationModel({
    this.id,
    required this.categoryId,
    required this.subcategory,
    required this.imageUrl,
    required this.location,
    required this.address,
    required this.title,
    this.like = 0,
    this.recommendation = 0,
  });
  // Convert to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'categoryId': categoryId,
      'subcategory': subcategory,
      'imageUrl': imageUrl,
      'location': location,
      'address': address,
      'title': title,
      'like': like,
      'recommendation': recommendation,
    };
  }
  // Create from Firestore document
  factory DestinationModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return DestinationModel(
      id: doc.id,
      categoryId: data['categoryId'] ?? '',
      subcategory: data['subcategory'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      location: data['location'] ?? const GeoPoint(0, 0),
      address: data['address'] ?? '',
      title: data['title'] ?? '',
      like: data['like'] ?? 0,
      recommendation: data['recommendation'] ?? 0,
    );
  }

  // Create from Map
  factory DestinationModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return DestinationModel(
      id: id,
      categoryId: map['categoryId'] ?? '',
      subcategory: map['subcategory'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      location: map['location'] ?? const GeoPoint(0, 0),
      address: map['address'] ?? '',
      title: map['title'] ?? '',
      like: map['like'] ?? 0,
    );
  }

  // Copy with method
  DestinationModel copyWith({
    String? id,
    String? categoryId,
    String? subcategory,
    String? imageUrl,
    GeoPoint? location,
    String? address,
    String? title,
    int? like,
  }) {
    return DestinationModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      subcategory: subcategory ?? this.subcategory,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      address: address ?? this.address,
      title: title ?? this.title,
      like: like ?? this.like,
    );
  }

  @override
  String toString() {
    return 'DestinationModel(id: $id, title: $title, categoryId: $categoryId, like: $like)';
  }
}
