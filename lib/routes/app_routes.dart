import 'package:flutter/widgets.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/signup_page.dart';

class AppRoutes {
  static const login = '/login';
  static const signup = '/signup';

  static Map<String, WidgetBuilder> get routes => {
        login: (_) => const LoginPage(),
        signup: (_) => const SignupPage(),
      };
}