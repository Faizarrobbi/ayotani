import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import 'pages/auth/login_page.dart';
import 'routes/app_routes.dart';

// --- CONFIGURATION ---
// I have turned off mock data. The app will now attempt to connect to your real database.
const bool useMockData = false; 

// YOUR SUPABASE CREDENTIALS
const String supabaseUrl = 'https://djayruwdyfndnfskgtit.supabase.co';

// WARNING: The key you provided appears to be a Publishable Key, not the standard JWT Anon Key.
// If connection fails, replace this with the 'anon' 'public' key from Supabase Settings -> API.
// It usually starts with "eyJ..."
const String supabaseAnonKey = 'sb_publishable_lTBN1VXJKHhw19KIKlk9nA_jMSs0Kb2';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (!useMockData) {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  runApp(const AyoTaniApp());
}

// --- DESIGN SYSTEM ---
class AppColors {
  static const Color primary = Color(0xFF0B6138); // Green
  static const Color secondary = Color(0xFF0B5F61); // Teal
  static const Color background = Color(0xFFF5F5F5);
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textGrey = Color(0xFF757575);
}

class AyoTaniApp extends StatelessWidget {
  const AyoTaniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ayo Tani',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),
        textTheme: TextTheme(
          displayLarge: GoogleFonts.kanit(fontWeight: FontWeight.bold, color: AppColors.textDark),
          displayMedium: GoogleFonts.kanit(fontWeight: FontWeight.bold, color: AppColors.textDark),
          titleLarge: GoogleFonts.kanit(fontWeight: FontWeight.w600, color: AppColors.textDark),
          titleMedium: GoogleFonts.kanit(fontWeight: FontWeight.w500, color: AppColors.textDark),
          bodyLarge: GoogleFonts.inter(color: AppColors.textDark),
          bodyMedium: GoogleFonts.inter(color: AppColors.textDark),
          bodySmall: GoogleFonts.inter(color: AppColors.textGrey),
        ),
        useMaterial3: true,
      ),
      routes: AppRoutes.routes,
      home: const LoginPage(),
    );
  }
}

// --- MODELS ---
class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String imageUrl;
  final String category;
  final double rating;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.category,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      stock: json['stock'] ?? 0,
      imageUrl: json['image_url'] ?? '',
      category: json['category'] ?? 'Tools',
      rating: (json['rating'] as num).toDouble(),
    );
  }
}

// --- SCREEN A: MARKETPLACE HOME ---
class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  String selectedCategory = 'All';
  final List<String> categories = ['All', 'Seeds', 'Nutrient', 'Tools', 'Growth Promoter'];
  
  // Fetch logic
  Future<List<Product>> _fetchProducts() async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 800)); // Simulate net lag
      return [
        Product(id: 1, name: 'Benih Tomat Cherry', description: 'Benih unggul tomat cherry merah manis, cocok untuk dataran rendah hingga tinggi. Masa panen 60-70 hari setelah tanam.', price: 15000, stock: 50, imageUrl: 'https://images.unsplash.com/photo-1592841200221-a6898f307baa?auto=format&fit=crop&q=80&w=400', category: 'Seeds', rating: 4.8),
        Product(id: 2, name: 'Pupuk Organik Cair', description: 'Mempercepat pertumbuhan daun dan akar. Terbuat dari bahan alami yang ramah lingkungan.', price: 45000, stock: 20, imageUrl: 'https://images.unsplash.com/photo-1585314062340-f1a5a7c9328d?auto=format&fit=crop&q=80&w=400', category: 'Nutrient', rating: 4.5),
        Product(id: 3, name: 'Sekop Taman Baja', description: 'Sekop tangan anti karat dengan gagang ergonomis. Kuat untuk tanah keras.', price: 28000, stock: 15, imageUrl: 'https://images.unsplash.com/photo-1416879115533-b96377132f62?auto=format&fit=crop&q=80&w=400', category: 'Tools', rating: 4.9),
        Product(id: 4, name: 'Benih Cabai Rawit', description: 'Cabai rawit super pedas, tahan hama dan penyakit.', price: 12000, stock: 100, imageUrl: 'https://images.unsplash.com/photo-1596525166986-e91be8606c48?auto=format&fit=crop&q=80&w=400', category: 'Seeds', rating: 4.7),
      ];
    } else {
      final client = Supabase.instance.client;
      var query = client.from('products').select();
      
      // Filter Logic
      if (selectedCategory != 'All') {
        // Ensure category matches the Enum strings in database exactly
        query = query.eq('category', selectedCategory);
      }
      
      try {
        final response = await query;
        return (response as List).map((e) => Product.fromJson(e)).toList();
      } catch (e) {
        // Simple error handling for debugging
        debugPrint('Supabase Error: $e');
        rethrow;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // HEADER: App Bar & Search
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: AppColors.primary,
            elevation: 0,
            title: Text('Marketplace', style: GoogleFonts.kanit(color: Colors.white, fontWeight: FontWeight.bold)),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari benih, pupuk...',
                      hintStyle: GoogleFonts.inter(color: Colors.grey),
                      prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // FILTER CHIPS
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: categories.map((cat) {
                    final isSelected = selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (bool value) {
                          setState(() {
                            selectedCategory = cat;
                          });
                        },
                        backgroundColor: Colors.white,
                        selectedColor: AppColors.secondary.withOpacity(0.2),
                        labelStyle: GoogleFonts.inter(
                          color: isSelected ? AppColors.primary : AppColors.textDark,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected ? AppColors.primary : Colors.grey.shade300,
                          ),
                        ),
                        showCheckmark: false,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          // PROMO BANNER
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              height: 140,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.secondary, AppColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -20,
                    bottom: -20,
                    child: Icon(Icons.local_florist, size: 150, color: Colors.white.withOpacity(0.1)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(4)),
                          child: Text('FLASHSALE', style: GoogleFonts.kanit(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 8),
                        Text('Diskon 50% Pupuk', style: GoogleFonts.kanit(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                        Text('Berlaku sampai besok!', style: GoogleFonts.inter(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // PRODUCT GRID
          FutureBuilder<List<Product>>(
            future: _fetchProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: AppColors.primary)));
              }
              if (snapshot.hasError) {
                // Better error visualization
                return SliverFillRemaining(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 48, color: Colors.red),
                          const SizedBox(height: 10),
                          Text('Error loading products', style: GoogleFonts.kanit(fontSize: 18)),
                          const SizedBox(height: 5),
                          Text(
                            '${snapshot.error}', 
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 10),
                          Text('Check your API Key in main.dart', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.red)),
                        ],
                      ),
                    ),
                  )
                );
              }
              final products = snapshot.data ?? [];
              
              if (products.isEmpty) {
                 return SliverFillRemaining(
                  child: Center(
                    child: Text('No products found in database.', style: GoogleFonts.inter(color: Colors.grey)),
                  )
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = products[index];
                      return ProductCard(product: product);
                    },
                    childCount: products.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// --- WIDGET: PRODUCT CARD ---
class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.simpleCurrency(locale: 'id_ID', decimalDigits: 0);

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Hero(
                  tag: 'product-${product.id}',
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    placeholder: (context, url) => Container(color: Colors.grey.shade100),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey.shade100,
                      child: const Icon(Icons.image_not_supported, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
            // Details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.kanit(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(product.rating.toString(), style: GoogleFonts.inter(fontSize: 12, color: AppColors.textGrey)),
                      ],
                    ),
                    Text(
                      formatCurrency.format(product.price),
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- SCREEN B: PRODUCT DETAIL ---
class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.simpleCurrency(locale: 'id_ID', decimalDigits: 0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                backgroundColor: AppColors.primary,
                pinned: true,
                leading: IconButton(
                  icon: const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.arrow_back, color: AppColors.primary)),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'product-${widget.product.id}',
                    child: CachedNetworkImage(
                      imageUrl: widget.product.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Tag
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(color: AppColors.secondary.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
                        child: Text(widget.product.category, style: GoogleFonts.inter(color: AppColors.secondary, fontWeight: FontWeight.w600, fontSize: 12)),
                      ),
                      const SizedBox(height: 10),
                      // Title
                      Text(widget.product.name, style: GoogleFonts.kanit(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                      const SizedBox(height: 5),
                      // Rating & Stock
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 5),
                          Text('${widget.product.rating} (120 Review)', style: GoogleFonts.inter(color: AppColors.textGrey)),
                          const Spacer(),
                          Text('Stok: ${widget.product.stock}', style: GoogleFonts.inter(color: AppColors.primary, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Price
                      Text(formatCurrency.format(widget.product.price), style: GoogleFonts.kanit(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 10),
                      // Description
                      Text('Deskripsi Produk', style: GoogleFonts.kanit(fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Text(widget.product.description, style: GoogleFonts.inter(fontSize: 14, height: 1.5, color: Colors.grey.shade700)),
                      const SizedBox(height: 100), // Spacing for bottom bar
                    ],
                  ),
                ),
              ),
            ],
          ),

          // BOTTOM BAR
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))],
              ),
              child: Row(
                children: [
                  // Quantity Selector
                  Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        IconButton(icon: const Icon(Icons.remove, size: 18), onPressed: () => setState(() => quantity = quantity > 1 ? quantity - 1 : 1)),
                        Text('$quantity', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                        IconButton(icon: const Icon(Icons.add, size: 18), onPressed: () => setState(() => quantity++)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Add to Cart Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ditambahkan $quantity ${widget.product.name} ke keranjang')));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text('Tambah ke Keranjang', style: GoogleFonts.kanit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}