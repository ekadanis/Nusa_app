import '../models/models.dart';
import '../services/firestore_service.dart';

class UserSeeder {
  static Future<String> seedUsers() async {
    try {
      final userQuery = await FirestoreService.usersCollection
          .where('name', isEqualTo: 'Zhafran Arise')
          .get();

      if (userQuery.docs.isEmpty) {
        final user = UserModel(
          name: 'Zhafran Arise',
          email: 'zhafran.arise@example.com',
          password: 'password123',
        );

        final docRef =
            await FirestoreService.usersCollection.add(user.toFirestore());

        return docRef.id;
      } else {
        final userId = userQuery.docs.first.id;
        return userId;
      }
    } catch (e) {
      rethrow;
    }
  }
}
