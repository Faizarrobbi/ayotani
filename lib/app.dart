import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'theme/app_colors.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Providers are already injected in main.dart, so we just build the MaterialApp here
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ayo Tani',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.green),
        fontFamily: 'Inter',
      ),
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}