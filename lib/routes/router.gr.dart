// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

/// generated route for
/// [AccountPage]
class AccountRoute extends PageRouteInfo<void> {
  const AccountRoute({List<PageRouteInfo>? children})
    : super(AccountRoute.name, initialChildren: children);

  static const String name = 'AccountRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AccountPage();
    },
  );
}

/// generated route for
/// [DashboardPage]
class DashboardRoute extends PageRouteInfo<void> {
  const DashboardRoute({List<PageRouteInfo>? children})
    : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DashboardPage();
    },
  );
}

/// generated route for
/// [FeedsPage]
class FeedsRoute extends PageRouteInfo<void> {
  const FeedsRoute({List<PageRouteInfo>? children})
    : super(FeedsRoute.name, initialChildren: children);

  static const String name = 'FeedsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FeedsPage();
    },
  );
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomePage();
    },
  );
}

/// generated route for
/// [ImageAnalyzerPage]
class ImageAnalyzerRoute extends PageRouteInfo<void> {
  const ImageAnalyzerRoute({List<PageRouteInfo>? children})
    : super(ImageAnalyzerRoute.name, initialChildren: children);

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
    required XFile pickedImage,
    List<PageRouteInfo>? children,
  }) : super(
         ImageConfirmationRoute.name,
         args: ImageConfirmationRouteArgs(key: key, pickedImage: pickedImage),
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
      );
    },
  );
}

class ImageConfirmationRouteArgs {
  const ImageConfirmationRouteArgs({this.key, required this.pickedImage});

  final Key? key;

  final XFile pickedImage;

  @override
  String toString() {
    return 'ImageConfirmationRouteArgs{key: $key, pickedImage: $pickedImage}';
  }
}

/// generated route for
/// [ImageResultPage]
class ImageResultRoute extends PageRouteInfo<ImageResultRouteArgs> {
  ImageResultRoute({
    Key? key,
    required XFile image,
    List<PageRouteInfo>? children,
  }) : super(
         ImageResultRoute.name,
         args: ImageResultRouteArgs(key: key, image: image),
         initialChildren: children,
       );

  static const String name = 'ImageResultRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ImageResultRouteArgs>();
      return ImageResultPage(key: args.key, image: args.image);
    },
  );
}

class ImageResultRouteArgs {
  const ImageResultRouteArgs({this.key, required this.image});

  final Key? key;

  final XFile image;

  @override
  String toString() {
    return 'ImageResultRouteArgs{key: $key, image: $image}';
  }
}

/// generated route for
/// [KatalogProdukPage]
class KatalogProdukRoute extends PageRouteInfo<KatalogProdukRouteArgs> {
  KatalogProdukRoute({
    Key? key,
    String? categoryName,
    List<PageRouteInfo>? children,
  }) : super(
         KatalogProdukRoute.name,
         args: KatalogProdukRouteArgs(key: key, categoryName: categoryName),
         initialChildren: children,
       );

  static const String name = 'KatalogProdukRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<KatalogProdukRouteArgs>(
        orElse: () => const KatalogProdukRouteArgs(),
      );
      return KatalogProdukPage(key: args.key, categoryName: args.categoryName);
    },
  );
}

class KatalogProdukRouteArgs {
  const KatalogProdukRouteArgs({this.key, this.categoryName});

  final Key? key;

  final String? categoryName;

  @override
  String toString() {
    return 'KatalogProdukRouteArgs{key: $key, categoryName: $categoryName}';
  }
}

/// generated route for
/// [NusaBotPage]
class NusaBotRoute extends PageRouteInfo<void> {
  const NusaBotRoute({List<PageRouteInfo>? children})
    : super(NusaBotRoute.name, initialChildren: children);

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
    : super(OnboardingRoute.name, initialChildren: children);

  static const String name = 'OnboardingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OnboardingPage();
    },
  );
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashPage();
    },
  );
}
