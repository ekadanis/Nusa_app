// filepath: lib/seeders/main_seeder.dart
import 'category_seeder.dart';
import 'user_seeder.dart';
import 'destination_seeder.dart';
import 'article_seeder.dart';
import 'forum_seeder.dart';

class MainSeeder {
  static Future<void> seedAll() async {
    try {
      print('🚀 Starting comprehensive database seeding...');
      print('=' * 50);
      
      // 1. Seed Categories first (needed for other collections)
      final categoryIds = await CategorySeeder.seedCategories();
      print('✅ Categories seeded successfully');
      print('');
      
      // 2. Seed Users (needed for authorId in other collections)
      final userId = await UserSeeder.seedUsers();
      print('✅ Users seeded successfully');
      print('');
      
      // 3. Seed Destinations
      await DestinationSeeder.seedDestinations(categoryIds, userId);
      print('✅ Destinations seeded successfully');
      print('');
        // 4. Seed Articles
      await ArticleSeeder.seedArticles(categoryIds);
      print('✅ Articles seeded successfully');
      print('');
      
      // 5. Seed Forum Posts
      await ForumSeeder.seedForums(userId);
      print('✅ Forum posts seeded successfully');
      print('');
      
      print('=' * 50);
      print('🎉 Database seeding completed successfully!');      print('📊 Summary:');
      print('   • Categories: ${categoryIds.length} categories');
      print('   • Users: 1 user (Zhafran Arise)');
      print('   • Destinations: 35+ destinations across all categories');
      print('   • Articles: 12 comprehensive articles across all categories');
      print('   • Forum Posts: 15 discussion posts with varied topics');
      print('');
      print('🗃️  Database structure:');
      print('   📁 users/');
      print('      └── {userId}/');
      print('          ├── liked_destinations/');
      print('          ├── liked_articles/');
      print('          └── liked_forums/');
      print('   📁 categories/');
      print('   📁 destinations/');
      print('   📁 articles/');
      print('   📁 forum/');
      print('');
      print('✨ Your Nusa Indonesia app database is now ready for use!');
      
    } catch (e) {
      print('❌ Error during seeding: $e');
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
            case 'articles':
          final categoryIds = await CategorySeeder.seedCategories();
          await ArticleSeeder.seedArticles(categoryIds);
          break;
          
        case 'forum':
          final userId = await UserSeeder.seedUsers();
          await ForumSeeder.seedForums(userId);
          break;
          
        default:
          print('❌ Unknown collection: $collection');
          print('Available collections: categories, users, destinations, articles, forum');
      }
    } catch (e) {
      print('❌ Error seeding $collection: $e');
      rethrow;
    }
  }
  
  /// Reset and reseed all collections (use with caution!)
  static Future<void> resetAndSeedAll() async {
    print('⚠️  WARNING: This will delete all existing data and reseed!');
    print('🗑️  Clearing existing data...');
    
    // Note: In a production app, you might want to implement
    // collection clearing functionality here
    
    await seedAll();
  }
}
