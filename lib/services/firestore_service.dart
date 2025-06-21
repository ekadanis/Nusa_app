import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';
import '../seeders/seeders.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Collection references
  static CollectionReference get usersCollection =>
      _firestore.collection('users');
  static CollectionReference get categoriesCollection =>
      _firestore.collection('categories');
  static CollectionReference get destinationsCollection =>
      _firestore.collection('destinations');
  static CollectionReference get articlesCollection =>
      _firestore.collection('articles');
  static CollectionReference get forumsCollection =>
      _firestore.collection('forums');
  static CollectionReference get commentsCollection =>
      _firestore.collection('comments');
  static CollectionReference get feedsCollection =>
      _firestore.collection('feeds');

  // User subcollections
  static CollectionReference getUserLikedDestinations(String userId) {
    return usersCollection.doc(userId).collection('likedDestinations');
  }

  static CollectionReference getUserLikedArticles(String userId) {
    return usersCollection.doc(userId).collection('likedArticles');
  }

  static CollectionReference getUserLikedForumPosts(String userId) {
    return usersCollection.doc(userId).collection('likedForumPosts');
  } // Inisialisasi database dengan seeding lengkap

  static Future<void> initializeDatabase() async {
    try {
      // Inisialisasi database Nusa Indonesia
      await MainSeeder.seedAll();
      // Database berhasil diinisialisasi
    } catch (e) {
      // Error saat inisialisasi database
      rethrow;
    }
  }

  // Inisialisasi koleksi spesifik (untuk seeding yang ditargetkan)
  static Future<void> initializeCollection(String collection) async {
    try {
      // Inisialisasi koleksi tertentu
      await MainSeeder.seedSpecificCollection(collection);
      // Koleksi berhasil diinisialisasi
    } catch (e) {
      // Error saat inisialisasi koleksi
      rethrow;
    }
  }

  // Helper methods for CRUD operations
  // Operasi user
  static Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await usersCollection.doc(userId).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      // Error saat mengambil data user
      return null;
    }
  }

  static Future<UserModel?> getUserByEmail(String email) async {
    try {
      final query =
          await usersCollection.where('email', isEqualTo: email).get();
      if (query.docs.isNotEmpty) {
        return UserModel.fromFirestore(query.docs.first);
      }
      return null;
    } catch (e) {
      // Error saat mengambil user berdasarkan email
      return null;
    }
  }

  // Operasi like
  static Future<void> toggleDestinationLike(
      String userId, String destinationId) async {
    try {
      final likedDestinationsRef = getUserLikedDestinations(userId);
      final doc = await likedDestinationsRef.doc(destinationId).get();

      if (doc.exists) {
        // Hapus like
        await likedDestinationsRef.doc(destinationId).delete();
        // Kurangi jumlah like di koleksi destinations
        await _decrementLikeCount('destinations', destinationId);
      } else {
        // Tambah like
        await likedDestinationsRef.doc(destinationId).set({'isFavorite': true});
        // Tambah jumlah like di koleksi destinations
        await _incrementLikeCount('destinations', destinationId);
      }
    } catch (e) {
      // Error saat toggle like destination
    }
  }

  static Future<void> toggleArticleLike(String userId, String articleId) async {
    try {
      final likedArticlesRef = getUserLikedArticles(userId);
      final doc = await likedArticlesRef.doc(articleId).get();

      if (doc.exists) {
        await likedArticlesRef.doc(articleId).delete();
        await _decrementLikeCount('articles', articleId);
      } else {
        await likedArticlesRef.doc(articleId).set({'isFavorite': true});
        await _incrementLikeCount('articles', articleId);
      }
    } catch (e) {
      // Error saat toggle like artikel
    }
  }

  static Future<void> toggleForumLike(String userId, String forumId) async {
    try {
      final likedForumPostsRef = getUserLikedForumPosts(userId);
      final doc = await likedForumPostsRef.doc(forumId).get();

      if (doc.exists) {
        await likedForumPostsRef.doc(forumId).delete();
        await _decrementLikeCount('feeds', forumId);
      } else {
        await likedForumPostsRef.doc(forumId).set({'isFavorite': true});
        await _incrementLikeCount('feeds', forumId);
      }
    } catch (e) {
      // Error saat toggle like forum
    }
  }

  static Future<void> _incrementLikeCount(
      String collection, String docId) async {
    try {
      await _firestore.collection(collection).doc(docId).update({
        'like': FieldValue.increment(1),
      });
    } catch (e) {
      // Error saat menambah jumlah like
    }
  }

  static Future<void> _decrementLikeCount(
      String collection, String docId) async {
    try {
      await _firestore.collection(collection).doc(docId).update({
        'like': FieldValue.increment(-1),
      });
    } catch (e) {}
  }

  // Periksa apakah user menyukai item
  static Future<bool> hasUserLikedDestination(
      String userId, String destinationId) async {
    try {
      final doc =
          await getUserLikedDestinations(userId).doc(destinationId).get();
      return doc.exists;
    } catch (e) {
      // Error saat memeriksa like destination
      return false;
    }
  }

  static Future<bool> hasUserLikedArticle(
      String userId, String articleId) async {
    try {
      final doc = await getUserLikedArticles(userId).doc(articleId).get();
      return doc.exists;
    } catch (e) {
      // Error saat memeriksa like artikel
      return false;
    }
  }

  static Future<bool> hasUserLikedForumPost(
      String userId, String forumId) async {
    try {
      final doc = await getUserLikedForumPosts(userId).doc(forumId).get();
      return doc.exists;
    } catch (e) {
      // Error saat memeriksa like forum
      return false;
    }
  }

  // Metode pengambilan data
  static Future<List<CategoryModel>> getCategories() async {
    try {
      final snapshot = await categoriesCollection.get();
      return snapshot.docs
          .map((doc) => CategoryModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      // Error saat mengambil data kategori
      return [];
    }
  }

  static Future<String> getCategoryById(String Id) async {
    try {
      final doc = await categoriesCollection.doc(Id).get();
      if (doc.exists) {
        final categoryData = doc.data() as Map<String, dynamic>;
        return categoryData['categoryName'] ?? '';
      }
      return '';
    } catch (e) {
      // Error saat mengambil nama kategori
      return '';
    }
  }

  // Tambahkan di FirestoreService
  static Future<String> getCategoryIdByName(String categoryName) async {
    try {
      final snapshot = await categoriesCollection
          .where('categoryName', isEqualTo: categoryName)
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.id;
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  static Future<List<DestinationModel>> getDestinationsByCategory(
      String categoryId,
      {int limit = 5}) async {
    try {
      final snapshot = await destinationsCollection
          .where('categoryId', isEqualTo: categoryId)
          .limit(limit)
          .get();
      return snapshot.docs
          .map((doc) => DestinationModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      // Error saat mengambil destinasi berdasarkan kategori
      return [];
    }
  }

  static Future<List<DestinationModel>> searchDestinationsByTitle(String queryText) async {
    try {
      // Pastikan data 'title' di Firestore disimpan dalam huruf kecil (lowercase)
      // atau Anda memiliki field terpisah untuk pencarian lowercase (misal: 'title_lower').
      // Jika 'title' di Firestore masih menggunakan campuran huruf besar/kecil,
      // kueri ini tidak akan menemukan hasil kecuali Anda menambahkan index case-insensitive (tidak didukung secara native)
      // atau menyimpan data duplikat dalam lowercase.
      // final String lowercasedQuery = queryText.toLowerCase();

      final snapshot = await destinationsCollection
          .where('title', isGreaterThanOrEqualTo: queryText)
          .where('title', isLessThan: queryText + '\uf8ff') // Teknik untuk "startsWith"
          .get();

      print("Firestore query for '$queryText' (lowercased: '$queryText') returned ${snapshot.docs.length} documents."); // Debugging log

      return snapshot.docs
          .map((doc) => DestinationModel.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      // Tangani error spesifik dari Firebase, ini seringkali menunjukkan masalah indeks.
      print("FirebaseException in searchDestinationsByTitle: Code: ${e.code}, Message: ${e.message}");
      print("Pastikan Anda memiliki indeks Firestore untuk field 'title' (Ascending).");
      return [];
    } catch (e) {
      // Error umum saat mencari destinasi berdasarkan judul
      print("Error searching destinations by title: $e");
      return [];
    }
  }

  static Future<List<ArticleModel>> getArticles({int limit = 10}) async {
    try {
      final snapshot = await articlesCollection.limit(limit).get();
      return snapshot.docs
          .map((doc) => ArticleModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      // Error saat mengambil data artikel
      return [];
    }
  }

  static Future<List<ArticleModel>> getTopArticlesByLikes(
      {int limit = 5}) async {
    try {
      final snapshot = await articlesCollection
          .orderBy('like', descending: true)
          .limit(limit)
          .get();
      print("\n\n<<<ARTIKEL POPULER: ${snapshot.docs}\n\n");
      return snapshot.docs
          .map((doc) => ArticleModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      return [];
    }
  }

  static Future<List<ArticleModel>> getArticlesByCategory(String categoryId,
      {int limit = 10}) async {
    try {
      final snapshot = await articlesCollection
          .where('categoryId', isEqualTo: categoryId)
          .limit(limit)
          .get();
      print("\n\n<<<ISI CATEGORIES${snapshot.docs}\n\n");
      return snapshot.docs
          .map((doc) => ArticleModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      // Error saat mengambil artikel berdasarkan kategori
      return [];
    }
  }

  static Future<String> getCategoryNameById(String categoryId) async {
    try {
      final doc = await categoriesCollection.doc(categoryId).get();
      if (doc.exists) {
        final categoryData = doc.data() as Map<String, dynamic>;
        return categoryData['categoryName'].toString() ?? '';
      }
      return '';
    } catch (e) {
      return 'Gagal mengambil nama kategori';
    }
  }

  static Future<List<ForumModel>> getForumPosts({int limit = 15}) async {
    try {
      final snapshot = await forumsCollection.limit(limit).get();
      return snapshot.docs.map((doc) => ForumModel.fromFirestore(doc)).toList();
    } catch (e) {
      // Error saat mengambil data forum
      return [];
    }
  } // Metode pengambilan data dengan preferensi user

  static Future<List<DestinationModel>> getDestinationsByCategoryWithUserPrefs(
      String categoryId, String userId,
      {int limit = 5}) async {
    try {
      final destinations =
          await getDestinationsByCategory(categoryId, limit: limit);

      return destinations;
    } catch (e) {
      // Error saat mengambil destinasi dengan preferensi user
      return [];
    }
  }

  // Dapatkan destinasi dengan dukungan paginasi
  static Future<List<DestinationModel>> getDestinationsByCategoryPaginated(
      String categoryId,
      {int limit = 10,
      DocumentSnapshot? lastDocument}) async {
    try {
      Query query = destinationsCollection
          .where('categoryId', isEqualTo: categoryId)
          .limit(limit);
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }
      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => DestinationModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      // Error saat mengambil destinasi dengan paginasi
      return [];
    }
  }

  // Comment operations
  static Future<String?> addComment(CommentModel comment) async {
    try {
      final docRef = await commentsCollection.add(comment.toFirestore());

      // Update forum's comments count
      await _firestore.collection('feeds').doc(comment.forumId).update({
        'commentsCount': FieldValue.increment(1),
      });

      return docRef.id;
    } catch (e) {
      // Error saat menambah komentar
      return null;
    }
  }

  static Future<List<CommentModel>> getCommentsByForumId(String forumId) async {
    try {
      final snapshot = await commentsCollection
          .where('forumId', isEqualTo: forumId)
          .orderBy('date', descending: false)
          .get();
      return snapshot.docs
          .map((doc) => CommentModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      // Error saat mengambil komentar
      return [];
    }
  }

  static Future<int> getCommentsCount(String forumId) async {
    try {
      final snapshot = await commentsCollection
          .where('forumId', isEqualTo: forumId)
          .count()
          .get();
      return snapshot.count ?? 0;
    } catch (e) {
      // Error saat menghitung komentar
      return 0;
    }
  }
}
