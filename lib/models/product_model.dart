class Product {
  final int id;
  final String name;
  final String? description;
  final double price;
  final int stock;
  final String? imageUrl;
  final String category;
  final double rating;
  final DateTime? createdAt;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    this.imageUrl,
    required this.category,
    required this.rating,
    this.createdAt,
  });

  /// Creates a Product instance from a JSON map (Supabase response)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: _parseDouble(json['price']),
      stock: json['stock'] as int? ?? 0,
      imageUrl: json['image_url'] as String?,
      category: json['category'] as String? ?? 'Tools',
      rating: _parseDouble(json['rating']),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  /// Converts the Product instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'image_url': imageUrl,
      'category': category,
      'rating': rating,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  /// Helper method to safely parse numeric values from Supabase to double
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Returns the category with proper formatting
  String get categoryDisplay {
    return category.replaceAll('_', ' ');
  }

  @override
  String toString() => 'Product(id: $id, name: $name, price: $price)';
}
