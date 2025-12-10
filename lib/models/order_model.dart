enum OrderStatus { pending, processing, shipped, delivered, cancelled }

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Tertunda';
      case OrderStatus.processing:
        return 'Diproses';
      case OrderStatus.shipped:
        return 'Dikirim';
      case OrderStatus.delivered:
        return 'Terkirim';
      case OrderStatus.cancelled:
        return 'Dibatalkan';
    }
  }

  static OrderStatus fromString(String value) {
    return OrderStatus.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => OrderStatus.pending,
    );
  }
}

class Order {
  final int id;
  final String userId;
  final double totalPrice;
  final OrderStatus status;
  final String shippingAddress;
  final String? paymentMethod;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.userId,
    required this.totalPrice,
    this.status = OrderStatus.pending,
    required this.shippingAddress,
    this.paymentMethod,
    required this.createdAt,
  });

  /// Creates an Order instance from a JSON map (Supabase response)
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int,
      userId: json['user_id'] as String,
      totalPrice: _parseDouble(json['total_price']),
      status: OrderStatusExtension.fromString(json['status'] as String? ?? 'pending'),
      shippingAddress: json['shipping_address'] as String,
      paymentMethod: json['payment_method'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Converts the Order instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'total_price': totalPrice,
      'status': status.toString().split('.').last,
      'shipping_address': shippingAddress,
      'payment_method': paymentMethod,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Creates a copy of this order with updated fields
  Order copyWith({
    int? id,
    String? userId,
    double? totalPrice,
    OrderStatus? status,
    String? shippingAddress,
    String? paymentMethod,
    DateTime? createdAt,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Helper method to safely parse numeric values from Supabase to double
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  @override
  String toString() => 'Order(id: $id, total: Rp${totalPrice.toStringAsFixed(0)}, status: ${status.displayName})';
}
