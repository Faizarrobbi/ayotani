class OrderItem {
  final int id;
  final int orderId;
  final int? productId;
  final int quantity;
  final double priceAtPurchase;
  final DateTime createdAt;

  OrderItem({
    required this.id,
    required this.orderId,
    this.productId,
    this.quantity = 1,
    required this.priceAtPurchase,
    required this.createdAt,
  });

  /// Creates an OrderItem instance from a JSON map (Supabase response)
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as int,
      orderId: json['order_id'] as int,
      productId: json['product_id'] as int?,
      quantity: json['quantity'] as int? ?? 1,
      priceAtPurchase: _parseDouble(json['price_at_purchase']),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Converts the OrderItem instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'quantity': quantity,
      'price_at_purchase': priceAtPurchase,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Calculates the total price for this item
  double get totalPrice => priceAtPurchase * quantity;

  /// Helper method to safely parse numeric values from Supabase to double
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  @override
  String toString() =>
      'OrderItem(id: $id, orderId: $orderId, qty: $quantity, price: Rp${priceAtPurchase.toStringAsFixed(0)})';
}
