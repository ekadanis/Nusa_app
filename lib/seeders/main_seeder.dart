import 'category_seeder.dart';
import 'user_seeder.dart';
import 'destination_seeder.dart';
import 'forum_seeder.dart';

class MainSeeder {
  static Future<void> seedAll() async {
    try {
      final categoryIds = await CategorySeeder.seedCategories();
      final userId = await UserSeeder.seedUsers();
      await DestinationSeeder.seedDestinations(categoryIds, userId);
      await ForumSeeder.seedForums(userId);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> seedSpecificCollection(String collection) async {
    try {
      switch (collection.toLowerCase()) {
        case 'categories':
          await CategorySeeder.seedCategories();
          break;

        case 'users':
          await UserSeeder.seedUsers();
          break;

        case 'destinations':
          final categoryIds = await CategorySeeder.seedCategories();
          final userId = await UserSeeder.seedUsers();
          await DestinationSeeder.seedDestinations(categoryIds, userId);
          break;

        case 'forum':
          final userId = await UserSeeder.seedUsers();
          await ForumSeeder.seedForums(userId);
          break;

        default:
          break;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> resetAndSeedAll() async {
    await seedAll();
  }
}
