// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

/// generated route for
/// [DashboardPage]
class DashboardRoute extends PageRouteInfo<void> {
  const DashboardRoute({List<PageRouteInfo>? children})
      : super(
          DashboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'DashboardRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DashboardPage();
    },
  );
}

/// generated route for
/// [DetailScreenDestination]
class DetailRouteDestination extends PageRouteInfo<DetailRouteDestinationArgs> {
  DetailRouteDestination({
    Key? key,
    required DestinationModel destination,
    List<PageRouteInfo>? children,
  }) : super(
          DetailRouteDestination.name,
          args: DetailRouteDestinationArgs(
            key: key,
            destination: destination,
          ),
          initialChildren: children,
        );

  static const String name = 'DetailRouteDestination';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DetailRouteDestinationArgs>();
      return DetailScreenDestination(
        key: args.key,
        destination: args.destination,
      );
    },
  );
}

class DetailRouteDestinationArgs {
  const DetailRouteDestinationArgs({
    this.key,
    required this.destination,
  });

  final Key? key;

  final DestinationModel destination;

  @override
  String toString() {
    return 'DetailRouteDestinationArgs{key: $key, destination: $destination}';
  }
}

/// generated route for
/// [EditProfilePage]
class EditProfileRoute extends PageRouteInfo<void> {
  const EditProfileRoute({List<PageRouteInfo>? children})
      : super(
          EditProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'EditProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const EditProfilePage();
    },
  );
}

/// generated route for
/// [FeedsPage]
class FeedsRoute extends PageRouteInfo<void> {
  const FeedsRoute({List<PageRouteInfo>? children})
      : super(
          FeedsRoute.name,
          initialChildren: children,
        );

  static const String name = 'FeedsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FeedsPage();
    },
  );
}

/// generated route for
/// [ForumDetailPage]
class ForumDetailRoute extends PageRouteInfo<ForumDetailRouteArgs> {
  ForumDetailRoute({
    Key? key,
    required ForumModel forumPost,
    List<PageRouteInfo>? children,
  }) : super(
          ForumDetailRoute.name,
          args: ForumDetailRouteArgs(
            key: key,
            forumPost: forumPost,
          ),
          initialChildren: children,
        );

  static const String name = 'ForumDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ForumDetailRouteArgs>();
      return ForumDetailPage(
        key: args.key,
        forumPost: args.forumPost,
      );
    },
  );
}

class ForumDetailRouteArgs {
  const ForumDetailRouteArgs({
    this.key,
    required this.forumPost,
  });

  final Key? key;

  final ForumModel forumPost;

  @override
  String toString() {
    return 'ForumDetailRouteArgs{key: $key, forumPost: $forumPost}';
  }
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomePage();
    },
  );
}

/// generated route for
/// [HomePageQuiz]
class HomeRouteQuiz extends PageRouteInfo<void> {
  const HomeRouteQuiz({List<PageRouteInfo>? children})
      : super(
          HomeRouteQuiz.name,
          initialChildren: children,
        );

  static const String name = 'HomeRouteQuiz';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomePageQuiz();
    },
  );
}

/// generated route for
/// [ImageAnalyzerPage]
class ImageAnalyzerRoute extends PageRouteInfo<void> {
  const ImageAnalyzerRoute({List<PageRouteInfo>? children})
      : super(
          ImageAnalyzerRoute.name,
          initialChildren: children,
        );

  static const String name = 'ImageAnalyzerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ImageAnalyzerPage();
    },
  );
}

/// generated route for
/// [ImageConfirmationPage]
class ImageConfirmationRoute extends PageRouteInfo<ImageConfirmationRouteArgs> {
  ImageConfirmationRoute({
    Key? key,
    required File pickedImage,
    bool? isNotValid,
    List<PageRouteInfo>? children,
  }) : super(
          ImageConfirmationRoute.name,
          args: ImageConfirmationRouteArgs(
            key: key,
            pickedImage: pickedImage,
            isNotValid: isNotValid,
          ),
          initialChildren: children,
        );

  static const String name = 'ImageConfirmationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ImageConfirmationRouteArgs>();
      return ImageConfirmationPage(
        key: args.key,
        pickedImage: args.pickedImage,
        isNotValid: args.isNotValid,
      );
    },
  );
}

class ImageConfirmationRouteArgs {
  const ImageConfirmationRouteArgs({
    this.key,
    required this.pickedImage,
    this.isNotValid,
  });

  final Key? key;

  final File pickedImage;

  final bool? isNotValid;

  @override
  String toString() {
    return 'ImageConfirmationRouteArgs{key: $key, pickedImage: $pickedImage, isNotValid: $isNotValid}';
  }
}

/// generated route for
/// [ImageResultPage]
class ImageResultRoute extends PageRouteInfo<ImageResultRouteArgs> {
  ImageResultRoute({
    Key? key,
    required File image,

    List<PageRouteInfo>? children,
  }) : super(
          ImageResultRoute.name,
          args: ImageResultRouteArgs(
            key: key,
            image: image,
  
          ),
          initialChildren: children,
        );

  static const String name = 'ImageResultRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ImageResultRouteArgs>();
      return ImageResultPage(
        key: args.key,
        image: args.image,
   
      );
    },
  );
}

class ImageResultRouteArgs {
  const ImageResultRouteArgs({
    this.key,
    required this.image,
 
  });

  final Key? key;

  final File image;

 

  @override
  String toString() {
    return 'ImageResultRouteArgs{key: $key, image: $image}';
  }
}

/// generated route for
/// [InboxPage]
class InboxRoute extends PageRouteInfo<void> {
  const InboxRoute({List<PageRouteInfo>? children})
      : super(
          InboxRoute.name,
          initialChildren: children,
        );

  static const String name = 'InboxRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const InboxPage();
    },
  );
}

/// generated route for
/// [KatalogProdukPage]
class KatalogProdukRoute extends PageRouteInfo<KatalogProdukRouteArgs> {
  KatalogProdukRoute({
    Key? key,
    String? categoryName,
    String? categoryColor,
    List<PageRouteInfo>? children,
  }) : super(
          KatalogProdukRoute.name,
          args: KatalogProdukRouteArgs(
            key: key,
            categoryName: categoryName,
            categoryColor: categoryColor,
          ),
          initialChildren: children,
        );

  static const String name = 'KatalogProdukRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<KatalogProdukRouteArgs>(
          orElse: () => const KatalogProdukRouteArgs());
      return KatalogProdukPage(
        key: args.key,
        categoryName: args.categoryName,
        categoryColor: args.categoryColor,
      );
    },
  );
}

class KatalogProdukRouteArgs {
  const KatalogProdukRouteArgs({
    this.key,
    this.categoryName,
    this.categoryColor,
  });

  final Key? key;

  final String? categoryName;

  final String? categoryColor;

  @override
  String toString() {
    return 'KatalogProdukRouteArgs{key: $key, categoryName: $categoryName, categoryColor: $categoryColor}';
  }
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginPage();
    },
  );
}

/// generated route for
/// [NusaBotPage]
class NusaBotRoute extends PageRouteInfo<void> {
  const NusaBotRoute({List<PageRouteInfo>? children})
      : super(
          NusaBotRoute.name,
          initialChildren: children,
        );

  static const String name = 'NusaBotRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NusaBotPage();
    },
  );
}

/// generated route for
/// [OnboardingPage]
class OnboardingRoute extends PageRouteInfo<void> {
  const OnboardingRoute({List<PageRouteInfo>? children})
      : super(
          OnboardingRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OnboardingPage();
    },
  );
}

/// generated route for
/// [ProfilePage]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfilePage();
    },
  );
}

/// generated route for
/// [QuizHistoryPage]
class QuizHistoryRoute extends PageRouteInfo<void> {
  const QuizHistoryRoute({List<PageRouteInfo>? children})
      : super(
          QuizHistoryRoute.name,
          initialChildren: children,
        );

  static const String name = 'QuizHistoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const QuizHistoryPage();
    },
  );
}

/// generated route for
/// [QuizPage]
class QuizRoute extends PageRouteInfo<QuizRouteArgs> {
  QuizRoute({
    Key? key,
    required String categoryId,
    List<PageRouteInfo>? children,
  }) : super(
          QuizRoute.name,
          args: QuizRouteArgs(
            key: key,
            categoryId: categoryId,
          ),
          initialChildren: children,
        );

  static const String name = 'QuizRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<QuizRouteArgs>();
      return QuizPage(
        key: args.key,
        categoryId: args.categoryId,
      );
    },
  );
}

class QuizRouteArgs {
  const QuizRouteArgs({
    this.key,
    required this.categoryId,
  });

  final Key? key;

  final String categoryId;

  @override
  String toString() {
    return 'QuizRouteArgs{key: $key, categoryId: $categoryId}';
  }
}

/// generated route for
/// [QuizResultPage]
class QuizResultRoute extends PageRouteInfo<void> {
  const QuizResultRoute({List<PageRouteInfo>? children})
      : super(
          QuizResultRoute.name,
          initialChildren: children,
        );

  static const String name = 'QuizResultRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const QuizResultPage();
    },
  );
}

/// generated route for
/// [RegisterPage]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
      : super(
          RegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RegisterPage();
    },
  );
}

/// generated route for
/// [SearchResultsPage]
class SearchResultsRoute extends PageRouteInfo<SearchResultsRouteArgs> {
  SearchResultsRoute({
    Key? key,
    required String query,
    required List<DestinationModel> results,
    List<PageRouteInfo>? children,
  }) : super(
          SearchResultsRoute.name,
          args: SearchResultsRouteArgs(
            key: key,
            query: query,
            results: results,
          ),
          initialChildren: children,
        );

  static const String name = 'SearchResultsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SearchResultsRouteArgs>();
      return SearchResultsPage(
        key: args.key,
        query: args.query,
        results: args.results,
      );
    },
  );
}

class SearchResultsRouteArgs {
  const SearchResultsRouteArgs({
    this.key,
    required this.query,
    required this.results,
  });

  final Key? key;

  final String query;

  final List<DestinationModel> results;

  @override
  String toString() {
    return 'SearchResultsRouteArgs{key: $key, query: $query, results: $results}';
  }
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashPage();
    },
  );
}
