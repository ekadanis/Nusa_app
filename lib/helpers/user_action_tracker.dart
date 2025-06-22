import '../services/tracking_service.dart';
import '../features/account/services/achievement_service.dart';

/// Helper class untuk tracking user actions dan achievements
class UserActionTracker {
  
  /// Track ketika user membaca artikel
  /// Panggil ini di ArticlePage atau DetailArticlePage
  static Future<void> trackArticleRead(String articleId) async {
    try {
      await TrackingService.trackArticleRead(articleId);
      
      // Check achievements setelah tracking
      await AchievementService.checkAchievementsFromTracking();
      
      print('📚 Article read tracked and achievements checked');
    } catch (e) {
      print('Error tracking article read: $e');
    }
  }
  
  /// Track ketika user mengexplore kategori (klik widget kategori di beranda)
  /// Panggil ini ketika user klik pada CategoryCard atau category widget
  static Future<void> trackCategoryExplored(String categoryId) async {
    try {
      await TrackingService.trackCategoryExplored(categoryId);
      
      // Check achievements setelah tracking
      await AchievementService.checkAchievementsFromTracking();
      
      print('🗺️ Category explored tracked and achievements checked');
    } catch (e) {
      print('Error tracking category exploration: $e');
    }
  }
  
  /// Get category IDs untuk mapping
  static Map<String, String> getCategoryIds() {
    return {
      'Cultural Sites': 'cultural-sites',
      'Arts & Culture': 'arts-culture', 
      'Folk Instruments': 'folk-instruments',
      'Traditional Wear': 'traditional-wear',
      'Crafts & Artifacts': 'crafts-artifacts',
      'Local Foods': 'local-foods',
    };
  }
}

/*
IMPLEMENTASI DI WIDGET:

1. Untuk Article Widget/Card di Homepage:
```dart
onTap: () {
  // Track article exploration
  UserActionTracker.trackArticleRead(article.id);
  
  // Navigate to article detail
  context.router.push(ArticleRoute(article: article));
}
```

2. Untuk Category Widget/Card di Homepage:
```dart
onTap: () {
  // Track category exploration
  UserActionTracker.trackCategoryExplored(categoryId);
  
  // Navigate to category detail or quiz
  context.router.push(CategoryDetailRoute(categoryId: categoryId));
}
```

3. Untuk Quiz Category Selection:
```dart
onTap: () {
  // Track category exploration (akan otomatis track juga di quiz completion)
  UserActionTracker.trackCategoryExplored(categoryId);
  
  // Navigate to quiz
  context.router.push(QuizRoute(categoryId: categoryId));
}
```
*/
