import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // Static Address for demo (matches image)
  final String addressName = 'Leslie Lane';
  final String addressPhone = '+62 812 3456 7890';
  final String addressDetails = 'Jl Panjang 7-9 Kedoya Elok Plaza Bl DE/11, Kedoya Selatan, Jakarta, Kebon Jeruk, Indonesia 12345';

  // Shipping & Payment State
  String selectedPayment = 'Seabank'; // Default match image
  String deliveryDate = '6-8 Mar 2025';
  
  // Shipping cost logic matching image
  final double shippingCost = 9000;
  final double shippingDiscount = 9000; // Making it "Free" effectively as per image red text
  final double serviceFee = 1000;
  final double handlingFee = 1000;

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        // Calculate totals dynamically from CartProvider
        double productSubtotal = cart.totalPrice;
        double finalTotal = productSubtotal + shippingCost - shippingDiscount + serviceFee + handlingFee;

        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Checkout',
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            actions: [
               IconButton(
                icon: const Icon(Icons.headset_mic_outlined, color: AppColors.green),
                onPressed: () {},
              ),
            ],
          ),
          body: Column(
            children: [
              _buildStepper(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildAddressSection(),
                      const SizedBox(height: 8),
                      _buildItemsSection(cart), // Passing real cart data
                      const SizedBox(height: 8),
                      _buildDeliveryDateSection(),
                      const SizedBox(height: 8),
                      _buildShippingSection(),
                      const SizedBox(height: 8),
                      _buildPaymentSection(),
                      const SizedBox(height: 8),
                      _buildPaymentDetails(productSubtotal, finalTotal), // New detailed breakdown
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: _buildBottomBar(finalTotal),
        );
      },
    );
  }

  Widget _buildStepper() {
    return Container(
      padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
      color: const Color(0xFFF9F9F9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _stepIndicator('Review', true),
          _stepLine(),
          _stepIndicator('Payment', false),
          _stepLine(),
          _stepIndicator('Order', false),
        ],
      ),
    );
  }

  Widget _stepIndicator(String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? AppColors.green : Colors.grey[300]!,
              width: 5,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? Colors.black : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _stepLine() {
    return Expanded(
      child: Container(
        height: 2,
        color: Colors.grey[300],
        margin: const EdgeInsets.only(bottom: 20, left: 4, right: 4),
      ),
    );
  }

  Widget _buildAddressSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Text(addressName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: Colors.teal[100], borderRadius: BorderRadius.circular(4)),
                child: const Text('Utama', style: TextStyle(color: Colors.teal, fontSize: 10, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28, top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(addressPhone, style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 4),
                Text(addressDetails, style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.4)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItemsSection(CartProvider cart) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.storefront, size: 18, color: AppColors.green),
              SizedBox(width: 8),
              Text('Eka farm shop', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(height: 24),
          // Dynamic List from Cart
          ...cart.items.map((item) => Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[100],
                    image: item.imageUrl.isNotEmpty 
                      ? DecorationImage(image: NetworkImage(item.imageUrl), fit: BoxFit.cover)
                      : null,
                  ),
                  child: item.imageUrl.isEmpty ? const Icon(Icons.image, color: Colors.grey) : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.productName, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(4)),
                        child: const Text('Kategori', style: TextStyle(fontSize: 10, color: Colors.grey)),
                      ),
                      const SizedBox(height: 4),
                      Text('Rp${item.price.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.green)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A3D2F),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text('Qty ${item.quantity}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          )).toList(),
          
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Pesanan (${cart.totalSelectedItems} produk)', style: const TextStyle(fontSize: 13)),
              Text('Rp${cart.totalPrice.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.green)),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: 'Pesan...',
              hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDeliveryDateSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Delivery date', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(deliveryDate, style: const TextStyle(color: AppColors.green, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildShippingSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Hemat', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Image.network('https://upload.wikimedia.org/wikipedia/commons/9/92/SICEPAT_EKSPRES_LOGO.png', width: 40, errorBuilder: (c,o,s)=>const Icon(Icons.local_shipping, size: 16)),
                    const SizedBox(width: 8),
                    const Text('SiCepat Ekspress', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              Text('Rp${shippingCost.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPaymentSection() {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.pushNamed(context, AppRoutes.paymentMethod);
        if (result != null && result is Map) {
          setState(() {
            selectedPayment = result['paymentName'];
          });
        }
      },
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Payment', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Text(selectedPayment, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.green)),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentDetails(double subtotal, double finalTotal) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.receipt_long, color: Colors.orange, size: 20),
              SizedBox(width: 8),
              Text('Payment Details', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          _detailRow('Subtotal untuk Produk:', 'Rp${subtotal.toStringAsFixed(0)}'),
          _detailRow('Subtotal Pengiriman:', 'Rp${shippingCost.toStringAsFixed(0)}'),
          _detailRow('Diskon Pengiriman', '-Rp${shippingDiscount.toStringAsFixed(0)}', color: Colors.red),
          _detailRow('Biaya Layanan', 'Rp${serviceFee.toStringAsFixed(0)}'),
          _detailRow('Biaya Penanganan', 'Rp${handlingFee.toStringAsFixed(0)}'),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, {Color color = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildBottomBar(double finalTotal) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Rp${finalTotal.toStringAsFixed(0)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.green)),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context, 
                  AppRoutes.payment,
                  arguments: {
                    'totalAmount': finalTotal,
                    'paymentMethod': selectedPayment
                  }
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A3D2F),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Checkout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}