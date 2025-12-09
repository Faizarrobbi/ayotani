import 'package:flutter/material.dart';

// Model untuk Cart Item
class CartItem {
  final String id;
  final String shopName;
  final String productName;
  final String category;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  int quantity;
  final int? stock;
  bool isSelected;

  CartItem({
    required this.id,
    required this.shopName,
    required this.productName,
    required this.category,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    this.quantity = 1,
    this.stock,
    this.isSelected = false,
  });
}

// Model untuk Shop Group
class ShopGroup {
  final String shopName;
  final List<CartItem> items;
  bool isSelected;

  ShopGroup({
    required this.shopName,
    required this.items,
    this.isSelected = false,
  });
}

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({Key? key}) : super(key: key);

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  List<ShopGroup> shopGroups = [
    ShopGroup(
      shopName: 'Eka farm shop',
      items: [
        CartItem(
          id: '1',
          shopName: 'Eka farm shop',
          productName: 'Jual Pupuk Hantu (Hormon...',
          category: 'Kategori',
          price: 205000,
          originalPrice: 349000,
          imageUrl: 'assets/images/product1.png',
          quantity: 2,
        ),
        CartItem(
          id: '2',
          shopName: 'Eka farm shop',
          productName: 'Jual Alat Pertanian Manual...',
          category: 'Kategori',
          price: 195000,
          imageUrl: 'assets/images/product2.png',
          quantity: 1,
          stock: 3,
        ),
      ],
    ),
    ShopGroup(
      shopName: 'Eka farm shop',
      items: [
        CartItem(
          id: '3',
          shopName: 'Eka farm shop',
          productName: 'BENIH UNGGUL » Cabe Rawit...',
          category: 'Kategori',
          price: 64000,
          imageUrl: 'assets/images/product3.png',
          quantity: 2,
        ),
      ],
    ),
    ShopGroup(
      shopName: 'Eka farm shop',
      items: [
        CartItem(
          id: '4',
          shopName: 'Eka farm shop',
          productName: 'Jual Pupuk Phoska E | PaDi UMKM',
          category: 'Kategori',
          price: 149000,
          imageUrl: 'assets/images/product4.png',
          quantity: 2,
        ),
      ],
    ),
  ];

  int get totalSelectedItems {
    int count = 0;
    for (var group in shopGroups) {
      for (var item in group.items) {
        if (item.isSelected) count++;
      }
    }
    return count;
  }

  double get totalPrice {
    double total = 0;
    for (var group in shopGroups) {
      for (var item in group.items) {
        if (item.isSelected) {
          total += item.price * item.quantity;
        }
      }
    }
    return total;
  }

  void toggleShopSelection(int groupIndex) {
    setState(() {
      shopGroups[groupIndex].isSelected = !shopGroups[groupIndex].isSelected;
      for (var item in shopGroups[groupIndex].items) {
        item.isSelected = shopGroups[groupIndex].isSelected;
      }
    });
  }

  void toggleItemSelection(int groupIndex, int itemIndex) {
    setState(() {
      shopGroups[groupIndex].items[itemIndex].isSelected =
          !shopGroups[groupIndex].items[itemIndex].isSelected;

      // Update shop checkbox
      shopGroups[groupIndex].isSelected = shopGroups[groupIndex]
          .items
          .every((item) => item.isSelected);
    });
  }

  void updateQuantity(int groupIndex, int itemIndex, bool increment) {
    setState(() {
      var item = shopGroups[groupIndex].items[itemIndex];
      if (increment) {
        if (item.stock == null || item.quantity < item.stock!) {
          item.quantity++;
        }
      } else {
        if (item.quantity > 1) {
          item.quantity--;
        }
      }
    });
  }

  void removeItem(int groupIndex, int itemIndex) {
    setState(() {
      shopGroups[groupIndex].items.removeAt(itemIndex);
      if (shopGroups[groupIndex].items.isEmpty) {
        shopGroups.removeAt(groupIndex);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8E8E8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Keranjang',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: shopGroups.length,
              itemBuilder: (context, groupIndex) {
                return _buildShopGroup(groupIndex);
              },
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildShopGroup(int groupIndex) {
    final group = shopGroups[groupIndex];
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Shop Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => toggleShopSelection(groupIndex),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: group.isSelected
                            ? const Color(0xFF2D6A4F)
                            : const Color(0xFFE0E0E0),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(4),
                      color: group.isSelected
                          ? const Color(0xFF2D6A4F)
                          : Colors.white,
                    ),
                    child: group.isSelected
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.store, size: 20),
                const SizedBox(width: 8),
                Text(
                  group.shopName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right, size: 20),
              ],
            ),
          ),
          const Divider(height: 1),
          // Items
          ...List.generate(
            group.items.length,
            (itemIndex) => _buildCartItem(groupIndex, itemIndex),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(int groupIndex, int itemIndex) {
    final item = shopGroups[groupIndex].items[itemIndex];
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checkbox
          GestureDetector(
            onTap: () => toggleItemSelection(groupIndex, itemIndex),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                border: Border.all(
                  color: item.isSelected
                      ? const Color(0xFF2D6A4F)
                      : const Color(0xFFE0E0E0),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
                color: item.isSelected
                    ? const Color(0xFF2D6A4F)
                    : Colors.white,
              ),
              child: item.isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          // Product Image
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.image, size: 40, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item.category,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (item.originalPrice != null) ...[
                      Text(
                        'Rp${item.originalPrice!.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      'Rp${item.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (item.stock != null)
                      Text(
                        'Sisa ${item.stock}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.orange,
                        ),
                      ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => updateQuantity(groupIndex, itemIndex, false),
                          icon: const Icon(Icons.remove, size: 16),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFFF5F5F5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            minimumSize: const Size(24, 24),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            '${item.quantity}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => updateQuantity(groupIndex, itemIndex, true),
                          icon: const Icon(Icons.add, size: 16),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFF2D6A4F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            minimumSize: const Size(24, 24),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Delete Button
          IconButton(
            onPressed: () => removeItem(groupIndex, itemIndex),
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.expand_less, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        'Total ($totalSelectedItems)',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Rp${totalPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: totalSelectedItems > 0 ? () {} : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: totalSelectedItems > 0
                        ? const Color(0xFF2D6A4F)
                        : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Checkout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}