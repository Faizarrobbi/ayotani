import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart'; // Assuming you have this package based on other files

import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../models/land_model.dart';
import '../../routes/app_routes.dart';

// Screens
import '../monitoring/monitoring_screen.dart';
import '../marketplace/marketplace_screen.dart';
import '../community/community_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).loadUserProfile();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final profile = authProvider.userProfile;
          // Only Home Content (Index 0) is complex, others are standard screens
          if (_selectedIndex == 0) {
            return _HomeContent(userProfile: profile);
          }
          return _getScreenForIndex(_selectedIndex);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF0A3D2F),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedLabelStyle: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.storefront_outlined), label: 'Shop'),
          BottomNavigationBarItem(icon: Icon(Icons.eco_outlined), label: 'Plant'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline_rounded), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Profil'),
        ],
      ),
    );
  }

  Widget _getScreenForIndex(int index) {
    switch (index) {
      case 1: return const MarketplaceScreen();
      case 2: return const MonitoringScreen(); // "Plant" maps to Monitoring
      case 3: return const CommunityScreen();
      case 4: return const Center(child: Text("Profile Screen")); // Placeholder for Profile
      default: return const SizedBox();
    }
  }
}

class _HomeContent extends StatefulWidget {
  final dynamic userProfile;
  const _HomeContent({required this.userProfile});

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  // Data State
  Map<String, dynamic>? _weatherData;
  List<Land> _lands = [];
  List<Map<String, dynamic>> _videos = [];
  List<Map<String, dynamic>> _articles = [];
  String _selectedDifficulty = 'All';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllData();
  }

  Future<void> _fetchAllData() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    // 1. Fetch Lands (We need this first to get location for weather)
    final landsResponse = await Supabase.instance.client
        .from('lands')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    
    List<Land> lands = (landsResponse as List).map((e) => Land.fromJson(e)).toList();

    // 2. Fetch Weather based on first land or default to Surabaya
    // Coordinates for Surabaya: -7.2575, 112.7521
    // Ideally, Land model has lat/long. Assuming default for now.
    _fetchWeather(-7.2575, 112.7521);

    // 3. Fetch Videos (Educational Content)
    // Assuming 'type' column exists or using 'difficulty' to differentiate
    final videosResponse = await Supabase.instance.client
        .from('educational_content')
        .select()
        .limit(5);

    // 4. Fetch Articles (For now, reusing educational content, ideally fetch from 'articles' table)
    final articlesResponse = await Supabase.instance.client
        .from('educational_content')
        .select()
        .order('created_at', ascending: true) // Just to show different items
        .limit(5);

    if (mounted) {
      setState(() {
        _lands = lands;
        _videos = List<Map<String, dynamic>>.from(videosResponse);
        _articles = List<Map<String, dynamic>>.from(articlesResponse);
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchWeather(double lat, double long) async {
    try {
      // Using Open-Meteo for detailed data (Temp, Humidity, Rain, Wind)
      final url = Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$long&current=temperature_2m,relative_humidity_2m,precipitation,wind_speed_10m&timezone=auto');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            _weatherData = data['current'];
          });
        }
      }
    } catch (e) {
      debugPrint("Weather Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.userProfile?.username ?? 'Petani';
    final gems = (widget.userProfile?.gems ?? 0).toString();
    final level = (widget.userProfile?.level ?? 1).toString();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. HEADER SECTION
          _buildCustomHeader(name, level, gems),

          // 2. WEATHER WIDGET
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildWeatherCard(),
          ),

          const SizedBox(height: 24),

          // 3. LAHAN PERTANIAN
          _buildSectionHeader('Lahan Pertanian', () {
            // Navigate to full list
          }),
          const SizedBox(height: 12),
          _buildLandList(),

          const SizedBox(height: 24),

          // 4. VIDEO BELAJAR
          _buildSectionHeader('Video Belajar', () {}),
          const SizedBox(height: 12),
          _buildFilterChips(),
          const SizedBox(height: 16),
          _buildVideoList(),

          const SizedBox(height: 24),

          // 5. TOP ARTICLES
          _buildSectionHeader('Top Articles', () {}),
          const SizedBox(height: 12),
          _buildArticleList(),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- WIDGETS ---

  Widget _buildCustomHeader(String name, String level, String gems) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 220,
          decoration: const BoxDecoration(
            color: Color(0xFF0A3D2F), // Dark Green
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, size: 28, color: Colors.grey),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Halo, $name',
                              style: GoogleFonts.inter(
                                color: Colors.white, 
                                fontSize: 18, 
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(
                              'Mau belajar apa hari ini?',
                              style: GoogleFonts.inter(
                                color: Colors.white70, 
                                fontSize: 12
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Icon(Icons.notifications_outlined, color: Colors.white, size: 28),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Text(
                    'Level $level | $gems Gems',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFFFD700), 
                      fontSize: 12, 
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Search Bar
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ]
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      hintText: 'Cari sesuatu...',
                      hintStyle: GoogleFonts.inter(color: Colors.grey[400]),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherCard() {
    final temp = _weatherData?['temperature_2m']?.toString() ?? '--';
    final humidity = _weatherData?['relative_humidity_2m']?.toString() ?? '--';
    final rain = _weatherData?['precipitation']?.toString() ?? '0';
    final wind = _weatherData?['wind_speed_10m']?.toString() ?? '--';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1534088568595-a066f410bcda?auto=format&fit=crop&w=800&q=80'), // Scenic field
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken),
        ),
        boxShadow: [
          BoxShadow(color: Colors.green.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wb_sunny_rounded, color: Colors.orangeAccent, size: 48),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$temp°', style: GoogleFonts.inter(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold, height: 1.0)),
                  Text('Hari ini cukup cerah', style: GoogleFonts.inter(color: Colors.white.withOpacity(0.9), fontSize: 13)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildWeatherStat('$humidity%', 'Kelembapan'),
                _buildWeatherStat('$rain%', 'Hujan'),
                _buildWeatherStat('$wind mph/s', 'Angin'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
        const SizedBox(height: 2),
        Text(label, style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 10)),
      ],
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onSeeAll) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
          GestureDetector(
            onTap: onSeeAll,
            child: Text('SEE ALL >', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF0A3D2F), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildLandList() {
    if (_isLoading) return const SizedBox(height: 180, child: Center(child: CircularProgressIndicator()));
    
    // Empty State
    if (_lands.isEmpty) {
      return Container(
        height: 150,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_location_alt_outlined, size: 40, color: Colors.grey),
            const SizedBox(height: 8),
            Text("Belum ada lahan", style: GoogleFonts.inter(color: Colors.grey[600])),
            TextButton(
              onPressed: () {
                // Navigate to Add Land
              },
              child: const Text("Tambahkan Lahan", style: TextStyle(color: Color(0xFF0A3D2F))),
            )
          ],
        ),
      );
    }

    return SizedBox(
      height: 180,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _lands.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final land = _lands[index];
          // Use a static map placeholder or land image if available
          final imageUrl = land.imageUrl ?? 'https://api.mapbox.com/styles/v1/mapbox/satellite-v9/static/112.7521,-7.2575,15,0/400x400?access_token=pk.eyJ1IjoiZGVtb3VzZXIiLCJhIjoiY2w4Z3M5bHMyMDJmMQN1b3h5b3MifQ.placeholder';
          
          return Container(
            width: 260,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey[200],
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
                onError: (e, s) {}, // Handle error silently
              ),
            ),
            child: Stack(
              children: [
                // Gradient Overlay
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                    ),
                  ),
                ),
                // Card Content
                Positioned(
                  bottom: 12, left: 12, right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A3D2F).withOpacity(0.95),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.location_on, color: Colors.white, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                land.name, 
                                style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${land.areaSize} ha  •  ${land.location ?? 'Unknown'}', 
                                style: GoogleFonts.inter(color: Colors.white70, fontSize: 10),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Beginner', 'Intermediet', 'Advanced'];
    return SizedBox(
      height: 36,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedDifficulty == filter;
          return GestureDetector(
            onTap: () => setState(() => _selectedDifficulty = filter),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF0A3D2F) : const Color(0xFFF2F4F3),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                filter,
                style: GoogleFonts.inter(
                  color: isSelected ? Colors.white : Colors.grey[700],
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideoList() {
    if (_isLoading) return const SizedBox(height: 100, child: Center(child: CircularProgressIndicator()));
    
    final filteredVideos = _selectedDifficulty == 'All' 
        ? _videos 
        : _videos.where((v) => (v['difficulty'] as String?)?.toLowerCase() == _selectedDifficulty.toLowerCase()).toList();

    if (filteredVideos.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text("Tidak ada video untuk kategori ini.", style: GoogleFonts.inter(color: Colors.grey)),
      );
    }

    return SizedBox(
      height: 210,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: filteredVideos.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final video = filteredVideos[index];
          return SizedBox(
            width: 240,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.network(
                        video['thumbnail_url'] ?? 'https://via.placeholder.com/240x135',
                        height: 135, width: 240, fit: BoxFit.cover,
                        errorBuilder: (c, o, s) => Container(height: 135, color: Colors.grey[300]),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.3), shape: BoxShape.circle),
                        child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 24),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  video['title'] ?? 'Judul Video',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text('Free', style: GoogleFonts.inter(fontSize: 11, color: AppColors.green, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                    Text(' 4.5', style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[700])),
                    const SizedBox(width: 8),
                    Text('|  12k Views', style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[500])),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildArticleList() {
    if (_articles.isEmpty) return const SizedBox();

    return SizedBox(
      height: 220,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _articles.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final article = _articles[index];
          return Container(
            width: 260,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[100]!),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    article['thumbnail_url'] ?? 'https://via.placeholder.com/260x140',
                    height: 120, width: double.infinity, fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article['title'] ?? 'Artikel Pertanian',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13, height: 1.4),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('5 min read', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
                          const Icon(Icons.bookmark_border_rounded, size: 18, color: Colors.grey),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}