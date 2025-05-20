import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:nusa_app/features/onboarding/views/onboarding_page.dart';
import '../features/pages.dart';
import 'package:camera/camera.dart';
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
            page: DashboardRoute.page,
            path: '/dashboard',
            transitionsBuilder: TransitionsBuilders.fadeIn,
            durationInMilliseconds: 300,
            children: [
              CustomRoute<void>(
                page: InfoCenterRoute.page,
                path: '-info-center',
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
                page: AccountRoute.page,
                path: '-account',
                transitionsBuilder: TransitionsBuilders.fadeIn,
              ),
            ]),
        CustomRoute<void>(
          page: ImageAnalyzerRoute.page,
          path: '/image-analyzer',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute<void>(
          page: ImageConfirmationRoute.page,
          path: '/iamge-confirmation',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute<void>(
          page: ImageResultRoute.page,
          path: '/image-result',
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
      ];
}
