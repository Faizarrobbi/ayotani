// File: lib/routes/routes.dart
import 'package:flutter/widgets.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/signup_page.dart';
import '../pages/marketplace/marketplace_screen.dart';
import '../pages/news/news_article_detail_page.dart';

class AppRoutes {
  static const login = '/login';
  static const signup = '/signup';
  static const marketplace = '/marketplace';
  static const newsArticle = '/news-article';
  static const comments = '/comments';

  static Map<String, WidgetBuilder> get routes => {
        login: (_) => const LoginPage(),
        signup: (_) => const SignupPage(),
        marketplace: (_) => const MarketplaceScreen(),
        newsArticle: (_) => const NewsArticleDetailPage(),
        // comments route handled by onGenerateRoute karena butuh arguments
      };
}