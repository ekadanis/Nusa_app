import 'dart:io';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:nusa_app/features/auth/views/login_page.dart';
import 'package:nusa_app/features/feeds/views/forum_detail_page.dart';
import 'package:nusa_app/features/onboarding/views/onboarding_page.dart';
import 'package:nusa_app/features/homepage/homepage.dart';
import 'package:nusa_app/features/katalog_destination/katalog_destination.dart';
import '../features/homepage/widgets/search_result_page.dart';
import 'package:nusa_app/features/auth/views/register_page.dart';
import 'package:nusa_app/features/profile/views/profile_page.dart';
import 'package:nusa_app/features/profile/views/edit_profile_page.dart';
import '../features/pages.dart';
import '../models/destination_model.dart';
import '../models/forum_model.dart';
part 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
        CustomRoute<void>(
          page: SplashRoute.page,
          path: '/splash',
          initial: true,
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute<void>(
          page: OnboardingRoute.page,
          path: '/onboarding',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute<void>(
          page: KatalogProdukRoute.page,
          path: '/katalog-produk',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute<void>(
          page: LoginRoute.page,
          path: '/login',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute<void>(
          page: RegisterRoute.page,
          path: '/register',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute<void>(
          page: ForumDetailRoute.page,
          path: '/forum-detail',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute<void>(
            page: DashboardRoute.page,
            path: '/dashboard',
            transitionsBuilder: TransitionsBuilders.fadeIn,
            durationInMilliseconds: 300,
            children: [
              CustomRoute<void>(
                page: HomeRoute.page,
                path: '-homepage',
                transitionsBuilder: TransitionsBuilders.fadeIn,
              ),
              CustomRoute<void>(
                page: NusaBotRoute.page,
                path: '-nusabot',
                transitionsBuilder: TransitionsBuilders.fadeIn,
              ),
              CustomRoute<void>(
                page: ImageAnalyzerRoute.page,
                path: '-image-analyzer',
                transitionsBuilder: TransitionsBuilders.fadeIn,
              ),
              CustomRoute<void>(
                page: FeedsRoute.page,
                path: '-feeds',
                transitionsBuilder: TransitionsBuilders.fadeIn,
              ),
              CustomRoute<void>(
                page: ProfileRoute.page,
                path: '-profile',
                transitionsBuilder: TransitionsBuilders.fadeIn,
              ),
            ]),
        CustomRoute<void>(
          page: EditProfileRoute.page,
          path: '/edit-profile',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute<void>(
          page: ImageAnalyzerRoute.page,
          path: '/image-analyzer',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute<void>(
          page: ImageConfirmationRoute.page,
          path: '/image-confirmation',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute<void>(
          page: ImageResultRoute.page,
          path: '/image-result',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute<void>(
          page: DetailRouteDestination.page,
          path: '/detail-destination',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute<void>(
          page: InboxRoute.page,
          path: '/inbox',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute<void>(
   page: HomeRouteQuiz.page,
          path: '/quiz-home',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute<void>(
          page: QuizHistoryRoute.page,
          path: '/quiz-history',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute<void>(
          page: QuizRoute.page,
          path: '/quiz/:categoryId',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute<void>(
          page: QuizResultRoute.page,
          path: '/quiz-result',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
      ];
}
