import '../models/models.dart';
import '../services/firestore_service.dart';

class UserSeeder {
  static Future<String> seedUsers() async {
    print('👥 Seeding Users...');

    try {
      final userQuery = await FirestoreService.usersCollection
          .where('name', isEqualTo: 'Zhafran Arise')
          .get();

      if (userQuery.docs.isEmpty) {
        // Create the user
        final user = UserModel(
          name: 'Zhafran Arise',
          email: 'zhafran.arise@example.com',
          password: 'password123', // In real app, this should be hashed
        );

        final docRef =
            await FirestoreService.usersCollection.add(user.toFirestore());
        print('👤 Created user: Zhafran Arise with ID: ${docRef.id}');

        // Initialize empty liked collections structure
        print('📁 Liked collections structure ready for user: ${docRef.id}');

        return docRef.id;
      } else {
        final userId = userQuery.docs.first.id;
        print('👤 User "Zhafran Arise" already exists with ID: $userId');
        return userId;
      }
    } catch (e) {
      print('❌ Error creating user: $e');
      rethrow;
    }
  }
}
