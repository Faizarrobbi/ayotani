import 'package:flutter/widgets.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/signup_page.dart';
import '../pages/marketplace/marketplace_screen.dart';

class AppRoutes {
  static const login = '/login';
  static const signup = '/signup';
  static const marketplace = '/marketplace';

  static Map<String, WidgetBuilder> get routes => {
        login: (_) => const LoginPage(),
        signup: (_) => const SignupPage(),
        marketplace: (_) => const MarketplaceScreen(),
      };
}