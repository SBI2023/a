import 'package:flutter/material.dart';
import '../ui/choice_splash/view/choice_splash_view.dart';
import '../ui/login/view/login_view.dart';
import 'strings_manager.dart';

class Routes {
  static const String splashChoice = "/splashChoice";
  static const String loginRoute = "/login";
  // static const String registerRoute = "/register";
  static const String forgotPasswordRoute = "/forgotPassword";
  // static const String onBoardingRoute = "/onBoarding";
  static const String mainRoute = "/main";
  // static const String storeDetailsRoute = "/storeDetails";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashChoice:
        return MaterialPageRoute(builder: (_) => const ChoiceScreenView());
      case Routes.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginView());
      default:
        return MaterialPageRoute(builder: (_) => const ChoiceScreenView());
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text(AppStrings.noRouteFound),
              ),
              body: const Center(child: Text(AppStrings.noRouteFound)),
            ));
  }
}
