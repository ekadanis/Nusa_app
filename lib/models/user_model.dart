import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String name;
  final String email;
  final String password;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }

  // Create from Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
    );
  }

  // Create from Map
  factory UserModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }

  // Copy with method
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email)';
  }
}

// Subcollection models for liked items
class LikedDestination {
  final String destinationId;
  final bool isFavorite;

  LikedDestination({
    required this.destinationId,
    required this.isFavorite,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'isFavorite': isFavorite,
    };
  }

  factory LikedDestination.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return LikedDestination(
      destinationId: doc.id,
      isFavorite: data['isFavorite'] ?? false,
    );
  }
}

class LikedArticle {
  final String articleId;
  final bool isFavorite;

  LikedArticle({
    required this.articleId,
    required this.isFavorite,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'isFavorite': isFavorite,
    };
  }

  factory LikedArticle.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return LikedArticle(
      articleId: doc.id,
      isFavorite: data['isFavorite'] ?? false,
    );
  }
}

class LikedForumPost {
  final String forumId;
  final bool isFavorite;

  LikedForumPost({
    required this.forumId,
    required this.isFavorite,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'isFavorite': isFavorite,
    };
  }

  factory LikedForumPost.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return LikedForumPost(
      forumId: doc.id,
      isFavorite: data['isFavorite'] ?? false,
    );
  }
}
