import 'package:flutter/widgets.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/onboarding_page.dart';
import '../pages/auth/signup_page.dart';
import '../pages/auth/splash_screen.dart';
import '../pages/home/home_screen.dart';
import '../pages/marketplace/cart.dart';
import '../pages/marketplace/checkout.dart';
import '../pages/marketplace/marketplace_screen.dart';
import '../pages/marketplace/payment.dart';
import '../pages/marketplace/payment_done.dart';
import '../pages/marketplace/payment_method.dart';
import '../pages/education/educational_list_screen.dart';
import '../pages/education/educational_detail_screen.dart';

class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const signup = '/signup';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const marketplace = '/marketplace';
  static const cart = '/cart';
  static const checkout = '/checkout';
  static const paymentMethod = '/payment-method';
  static const payment = '/payment';
  static const paymentDone = '/payment-done';
  static const educational = '/educational';
  static const educationalDetail = '/educational-detail';

  static Map<String, WidgetBuilder> get routes => {
        splash: (_) => const SplashScreen(),
        login: (_) => const LoginPage(),
        signup: (_) => const SignupPage(),
        onboarding: (context) {
          final userId = ModalRoute.of(context)?.settings.arguments as String?;
          return OnboardingPage(userId: userId ?? '');
        },
        home: (_) => const HomeScreen(),
        marketplace: (_) => const MarketplaceScreen(),
        cart: (_) => const ShoppingCartScreen(),
        checkout: (_) => const CheckoutScreen(),
        paymentMethod: (_) => const PaymentMethodScreen(),
        payment: (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          return PaymentScreen(
            totalAmount: args?['totalAmount'] as double? ?? 0.0,
            paymentMethod: args?['paymentMethod'] as String? ?? 'Unknown',
          );
        },
        paymentDone: (_) => const PaymentDoneScreen(),
        educational: (_) => const EducationalListScreen(),
        educationalDetail: (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          final id = args?['id'] as int? ?? 0;
          return EducationalDetailScreen(contentId: id);
        },
      };
}
