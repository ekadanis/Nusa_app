import '../models/models.dart';
import '../services/firestore_service.dart';

class CategorySeeder {
  static Future<Map<String, String>> seedCategories() async {
    final categories = [
      CategoryModel(categoryName: 'Cultural Sites', title: 'Cultural Sites'),
      CategoryModel(categoryName: 'Arts & Culture', title: 'Arts & Culture'),
      CategoryModel(categoryName: 'Folk Instruments', title: 'Folk Instruments'),
      CategoryModel(categoryName: 'Traditional Wear', title: 'Traditional Wear'),
      CategoryModel(categoryName: 'Crafts & Artifacts', title: 'Crafts & Artifacts'),
      CategoryModel(categoryName: 'Local Foods', title: 'Local Foods'),
    ];

    Map<String, String> categoryIds = {};

    for (final category in categories) {
      final existingCategory = await FirestoreService.categoriesCollection
          .where('categoryName', isEqualTo: category.categoryName)
          .get();

      String categoryId;
      if (existingCategory.docs.isEmpty) {
        final docRef = await FirestoreService.categoriesCollection.add(category.toFirestore());
        categoryId = docRef.id;
      } else {
        categoryId = existingCategory.docs.first.id;
      }
      
      categoryIds[category.categoryName] = categoryId;
    }

    return categoryIds;
  }
}
