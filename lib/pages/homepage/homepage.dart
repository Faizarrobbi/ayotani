import 'package:flutter/material.dart';
// Import widget pecahan kamu di sini
import '../../widgets/home/header.dart';
import '../../widgets/home/weather.dart';
import '../../widgets/home/farmland.dart';
import '../../widgets/home/videolearn.dart';
import '../../widgets/home/article.dart';
import '../../routes/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) { // Shop
      Navigator.pushNamed(context, AppRoutes.marketplace);
    }
    // Add other navigation logic here for other tabs
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: const [
            HeaderSection(),
            SizedBox(height: 20),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: WeatherCard(),
            ),
            SizedBox(height: 25),

            // Panggil widget Lahan Pertanian
            FarmSection(),
            SizedBox(height: 25),

            // Panggil widget Video
            VideoSection(),
            SizedBox(height: 25),

            // Panggil widget Artikel
            ArticleSection(),
            SizedBox(height: 40),
          ],
        ),
      ),
      // Bottom Navigation bisa ditaruh di sini langsung atau dipisah juga
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF0B6138),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: "Shop"),
          BottomNavigationBarItem(icon: Icon(Icons.eco_outlined), label: "Plant"),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: "Community"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profil"),
        ],
      ),
    );
  }
}
