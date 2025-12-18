import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../routes/app_routes.dart';
import '../../providers/cart_provider.dart';
import '../../theme/app_colors.dart';
import '../../models/product_model.dart';
import 'product_detail_screen.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({Key? key}) : super(key: key);

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  late Future<List<Product>> _similarProductsFuture;

  @override
  void initState() {
    super.initState();
    _similarProductsFuture = _fetchSimilarProducts();
  }

  Future<List<Product>> _fetchSimilarProducts() async {
    try {
      // Fetch 4 random products for suggestions
      final response = await Supabase.instance.client
          .from('products')
          .select()
          .limit(4);
      
      return (response as List).map((item) => Product.fromJson(item)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF5F5F5),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black),
              // FIX: Handle navigation safely
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  // If no history (e.g. after purchase), go to Marketplace
                  Navigator.pushReplacementNamed(context, AppRoutes.marketplace);
                }
              },
            ),
            title: const Text(
              'Keranjang',
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
            ),
            centerTitle: true,
          ),
          body: cart.items.isEmpty 
              ? _buildEmptyState()
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Wrap items in a white container to mimic the "Shop Group" card
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  // Shop Header (Static due to schema limits)
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      children: [
                                        _buildCheckbox(true), // Shop checkbox
                                        const SizedBox(width: 12),
                                        const Icon(Icons.storefront, size: 18, color: AppColors.green),
                                        const SizedBox(width: 8),
                                        const Text('Eka farm shop', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                        const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
                                      ],
                                    ),
                                  ),
                                  const Divider(height: 1),
                                  
                                  // Items List
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: cart.items.length,
                                    itemBuilder: (context, index) {
                                      return _buildCartItemCard(cart, index);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            
                            // "Produk serupa" / Recommendations Section
                            const SizedBox(height: 24),
                            const Row(
                              children: [
                                Expanded(child: Divider()),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Text('Produk serupa', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                ),
                                Expanded(child: Divider()),
                              ],
                            ),
                            const SizedBox(height: 16),
                            
                            // Grid for Recommendations (Connected to DB)
                            FutureBuilder<List<Product>>(
                              future: _similarProductsFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator(color: AppColors.green));
                                }
                                final similarProducts = snapshot.data ?? [];
                                
                                return GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.7,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                  ),
                                  itemCount: similarProducts.length,
                                  itemBuilder: (context, index) => _buildRecommendationCard(context, similarProducts[index]),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    _buildBottomBar(cart),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Keranjang Kosong',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.green),
            child: const Text('Mulai Belanja', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  Widget _buildCheckbox(bool isSelected) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? AppColors.green : const Color(0xFFE0E0E0),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(4),
        color: isSelected ? AppColors.green : Colors.transparent,
      ),
      child: isSelected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
    );
  }

  Widget _buildCartItemCard(CartProvider cart, int index) {
    final item = cart.items[index];
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checkbox
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: GestureDetector(
              onTap: () => cart.toggleSelection(index),
              child: _buildCheckbox(item.isSelected),
            ),
          ),
          const SizedBox(width: 12),
          
          // Image
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
              image: item.imageUrl.isNotEmpty 
                  ? DecorationImage(image: NetworkImage(item.imageUrl), fit: BoxFit.cover)
                  : null,
            ),
            child: item.imageUrl.isEmpty 
                ? const Icon(Icons.image, size: 40, color: Colors.grey) 
                : null,
          ),
          const SizedBox(width: 12),
          
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.productName,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => cart.removeItem(index),
                      child: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Category Chip (Hardcoded as not in CartItem model usually, or extract from product if added)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('Product', style: TextStyle(fontSize: 10, color: Colors.grey)),
                ),
                const SizedBox(height: 4),
                // Price Row
                Row(
                  children: [
                     Text(
                      'Rp${(item.price * 1.2).toStringAsFixed(0)}', // Fake original price
                      style: TextStyle(fontSize: 11, color: Colors.grey[400], decoration: TextDecoration.lineThrough),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Rp${item.price.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.green),
                    ),
                  ],
                ),
                
                // Qty Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          _qtyButton(Icons.remove, () => cart.updateQuantity(index, false)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text('${item.quantity}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                          _qtyButton(Icons.add, () => cart.updateQuantity(index, true)),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(icon, size: 14, color: Colors.grey[600]),
      ),
    );
  }

  Widget _buildRecommendationCard(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product))),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                ),
                width: double.infinity,
                child: product.imageUrl != null 
                    ? Image.network(product.imageUrl!, fit: BoxFit.cover)
                    : const Center(child: Icon(Icons.image, color: Colors.white)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    color: Colors.grey[100],
                    child: Text(product.categoryDisplay, style: const TextStyle(fontSize: 8)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                   Row(
                    children: List.generate(5, (i) => Icon(
                      i < product.rating ? Icons.star : Icons.star_border, 
                      size: 10, 
                      color: AppColors.green
                    )),
                   ),
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

  Widget _buildBottomBar(CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.keyboard_arrow_up, size: 20),
                    const SizedBox(width: 4),
                    Text('Total (${cart.totalSelectedItems})', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Text(
                  'Rp${cart.totalPrice.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: cart.totalSelectedItems > 0
                    ? () => Navigator.pushNamed(context, AppRoutes.checkout)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  disabledBackgroundColor: Colors.grey,
                ),
                child: const Text('Checkout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}