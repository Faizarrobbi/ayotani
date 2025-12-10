import 'package:flutter/material.dart';
import '../models/product_model.dart';

class CartItem {
  final String id;
  final String shopName;
  final String productName;
  final String category;
  final double price;
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
    required this.imageUrl,
    this.quantity = 1,
    this.stock,
    this.isSelected = false,
  });
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalPrice => _items
      .where((item) => item.isSelected)
      .fold(0, (sum, item) => sum + (item.price * item.quantity));

  int get totalSelectedItems => _items.where((i) => i.isSelected).length;

  void addToCart(Product product) {
    final index = _items.indexWhere((item) => item.id == product.id.toString());

    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(
        id: product.id.toString(),
        shopName: 'Toko Tani Official',
        productName: product.name,
        category: product.categoryDisplay,
        price: product.price,
        imageUrl: product.imageUrl ?? '',
        quantity: 1,
        stock: product.stock,
        isSelected: true,
      ));
    }
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void updateQuantity(int index, bool increment) {
    if (increment) {
      _items[index].quantity++;
    } else {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      }
    }
    notifyListeners();
  }

  void toggleSelection(int index) {
    _items[index].isSelected = !_items[index].isSelected;
    notifyListeners();
  }
}