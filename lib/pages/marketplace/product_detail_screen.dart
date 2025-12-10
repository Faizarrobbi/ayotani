import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/product_model.dart';
import '../../theme/app_colors.dart';
import '../../providers/cart_provider.dart';
import '../../routes/app_routes.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<List<Product>> _recommendationsFuture;

  @override
  void initState() {
    super.initState();
    _recommendationsFuture = _fetchRecommendations();
  }

  Future<List<Product>> _fetchRecommendations() async {
    try {
      final response = await Supabase.instance.client
          .from('products')
          .select()
          .neq('id', widget.product.id)
          .limit(5); 
      return (response as List).map((item) => Product.fromJson(item)).toList();
    } catch (e) {
      return [];
    }
  }

  void _addToCart({bool navigate = false}) {
    if (widget.product.stock <= 0) return;
    
    Provider.of<CartProvider>(context, listen: false).addToCart(widget.product);
    
    if (navigate) {
       Navigator.pushNamed(context, AppRoutes.checkout);
    } else {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.product.name} ditambahkan ke keranjang!'),
          backgroundColor: AppColors.green,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: _buildCircleBtn(Icons.arrow_back, () => Navigator.pop(context)),
            actions: [
              _buildCircleBtn(Icons.shopping_cart_outlined, () => Navigator.pushNamed(context, AppRoutes.cart)),
              const SizedBox(width: 16),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Container(
                    color: Colors.grey[100],
                    height: double.infinity,
                    width: double.infinity,
                    child: widget.product.imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: widget.product.imageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (_,__) => const Center(child: CircularProgressIndicator(color: AppColors.green)),
                          )
                        : const Center(child: Icon(Icons.image, size: 80, color: Colors.grey)),
                  ),
                ],
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Title and Price
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Text(
                      widget.product.name,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Rp${widget.product.price.toStringAsFixed(0)}',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.green,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(Icons.inventory_2_outlined, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          widget.product.stock > 0 ? 'Stok tersedia: ${widget.product.stock}' : 'Stok habis',
                          style: TextStyle(fontSize: 12, color: widget.product.stock > 0 ? Colors.grey[600] : Colors.red),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(thickness: 4, color: Color(0xFFF5F5F5)),

                  // 2. Description
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Deskripsi Produk',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.product.description ?? 
                          'Tidak ada deskripsi tersedia for produk ini. Hubungi admin untuk informasi lebih lanjut.',
                          style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[800], height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  const Divider(thickness: 4, color: Color(0xFFF5F5F5)),

                  // 3. Shop Info (Static)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(0xFFE0E0E0),
                          child: Icon(Icons.store, color: Colors.grey),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text('Eka Farm Shop', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  const SizedBox(width: 4),
                                  Icon(Icons.verified, size: 14, color: AppColors.green),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text('Online 10 menit lalu', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.green),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                            minimumSize: const Size(0, 32),
                          ),
                          child: const Text('Kunjungi', style: TextStyle(color: AppColors.green, fontSize: 12)),
                        )
                      ],
                    ),
                  ),
                  const Divider(thickness: 4, color: Color(0xFFF5F5F5)),
                  
                  // Recommendations
                  Container(
                    color: const Color(0xFFF5F5F5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('Rekomendasi Lainnya', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 220,
                          child: FutureBuilder<List<Product>>(
                            future: _recommendationsFuture,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) return const SizedBox();
                              final recommendations = snapshot.data!;
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: recommendations.length,
                                itemBuilder: (context, index) => _buildRecommendationCard(context, recommendations[index]),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100), 
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              offset: const Offset(0, -4),
              color: Colors.black.withOpacity(0.05),
            ),
          ],
        ),
        padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
        child: Row(
          children: [
            // Chat Icon
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Icons.chat_bubble_outline, color: Colors.grey),
                onPressed: () {}, // Chat functionality to be implemented
              ),
            ),
            const SizedBox(width: 12),
            
            // Add to Cart Button (Outlined)
            Expanded(
              child: SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: widget.product.stock > 0 ? () => _addToCart(navigate: false) : null,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.green, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Keranjang', style: TextStyle(color: AppColors.green, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Buy Now / Checkout Button (Filled)
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: widget.product.stock > 0 ? () => _addToCart(navigate: true) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: const Text('Beli Langsung', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleBtn(IconData icon, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black, size: 20),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildRecommendationCard(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product))),
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl: product.imageUrl ?? '',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (_,__) => Container(color: Colors.grey[100]),
                  errorWidget: (_,__,___) => Container(color: Colors.grey[100], child: const Icon(Icons.image)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Rp${product.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.green)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}