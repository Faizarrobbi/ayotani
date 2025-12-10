import 'dart:developer' as developer;
import '../models/order_model.dart';
import '../models/order_item_model.dart';
import 'supabase_service.dart';

/// Service for handling orders and checkout
class OrderService {
  final _supabase = SupabaseService();

  /// Create a new order
  Future<Order?> createOrder({
    required String userId,
    required double totalPrice,
    required String shippingAddress,
    String? paymentMethod,
  }) async {
    try {
      final response = await _supabase.client
          .from('orders')
          .insert({
            'user_id': userId,
            'total_price': totalPrice,
            'status': 'pending',
            'shipping_address': shippingAddress,
            'payment_method': paymentMethod,
          })
          .select()
          .single();

      return Order.fromJson(response);
    } catch (e) {
      developer.log('Error creating order: $e');
      return null;
    }
  }

  /// Add item to order
  Future<OrderItem?> addOrderItem({
    required int orderId,
    required int productId,
    required int quantity,
    required double priceAtPurchase,
  }) async {
    try {
      final response = await _supabase.client
          .from('order_items')
          .insert({
            'order_id': orderId,
            'product_id': productId,
            'quantity': quantity,
            'price_at_purchase': priceAtPurchase,
          })
          .select()
          .single();

      return OrderItem.fromJson(response);
    } catch (e) {
      developer.log('Error adding order item: $e');
      return null;
    }
  }

  /// Get order with its items
  Future<Map<String, dynamic>?> getOrderWithItems(int orderId) async {
    try {
      final response = await _supabase.client
          .from('orders')
          .select(
              '''
          *,
          order_items (
            *,
            products (
              id,
              name,
              image_url,
              price
            )
          )
          ''')
          .eq('id', orderId)
          .single();

      return response;
    } catch (e) {
      developer.log('Error fetching order with items: $e');
      return null;
    }
  }

  /// Get user orders
  Future<List<Order>> getUserOrders(String userId) async {
    try {
      final response = await _supabase.client
          .from('orders')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => Order.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      developer.log('Error fetching user orders: $e');
      return [];
    }
  }

  /// Update order status
  Future<Order?> updateOrderStatus(int orderId, String newStatus) async {
    try {
      final response = await _supabase.client
          .from('orders')
          .update({
            'status': newStatus,
          })
          .eq('id', orderId)
          .select()
          .single();

      return Order.fromJson(response);
    } catch (e) {
      developer.log('Error updating order status: $e');
      return null;
    }
  }

  /// Cancel order
  Future<bool> cancelOrder(int orderId) async {
    try {
      await _supabase.client
          .from('orders')
          .update({'status': 'cancelled'})
          .eq('id', orderId);

      return true;
    } catch (e) {
      developer.log('Error cancelling order: $e');
      return false;
    }
  }

  /// Get order items for an order
  Future<List<OrderItem>> getOrderItems(int orderId) async {
    try {
      final response = await _supabase.client
          .from('order_items')
          .select()
          .eq('order_id', orderId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      developer.log('Error fetching order items: $e');
      return [];
    }
  }

  /// Stream user orders
  Stream<List<Order>> streamUserOrders(String userId) {
    return _supabase.client
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map((data) {
          return (data as List)
              .map((item) => Order.fromJson(item as Map<String, dynamic>))
              .toList();
        });
  }

  /// Get order count for user
  Future<int> getUserOrderCount(String userId) async {
    try {
      final response = await _supabase.client
          .from('orders')
          .select('id')
          .eq('user_id', userId);

      return (response as List).length;
    } catch (e) {
      developer.log('Error fetching order count: $e');
      return 0;
    }
  }

  /// Get total spending for user
  Future<double> getUserTotalSpending(String userId) async {
    try {
      final response = await _supabase.client
          .from('orders')
          .select('total_price')
          .eq('user_id', userId);

      double total = 0;
      for (var order in response as List) {
        total += (order['total_price'] as num).toDouble();
      }
      return total;
    } catch (e) {
      developer.log('Error fetching total spending: $e');
      return 0;
    }
  }
}
