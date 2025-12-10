import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../providers/cart_provider.dart';

class PaymentScreen extends StatefulWidget {
  final double totalAmount;
  final String paymentMethod;

  const PaymentScreen({
    Key? key,
    required this.totalAmount,
    required this.paymentMethod,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // Demo VA number
  final String vaNumber = '781 0123 4567 890';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Payment', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.headset_mic_outlined, color: AppColors.green), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildStepper(),
            
            // Total Payment Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Pembayaran:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Rp${widget.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.green, fontSize: 16)),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Bank Info Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.savings, color: Colors.orange), // Seabank Logo placeholder
                      const SizedBox(width: 12),
                      Expanded(child: Text('${widget.paymentMethod} (dicek otomatis)', style: const TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  ),
                  const Divider(height: 24),
                  const Text('No. Rekening', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(vaNumber, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.green)),
                      InkWell(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: vaNumber));
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied!'), duration: Duration(seconds: 1)));
                        },
                        child: const Icon(Icons.copy, color: AppColors.green, size: 20),
                      )
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Instructions
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: const Text('Transfer Bank', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  initiallyExpanded: true,
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: const [
                    Text('1. Klik Buka Aplikasi Seabank dan log in ke akun Seabank\n2. Masuk ke halaman Transfer Virtual Account\n3. Pastikan jumlah benar\n4. Masukkan PIN anda.', style: TextStyle(height: 1.5, fontSize: 13)),
                  ],
                ),
              ),
            ),
             const SizedBox(height: 8),
             Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
               child: const ListTile(
                title: Text('Transfer Bank (manual)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                trailing: Icon(Icons.keyboard_arrow_down),
               ),
             ),

             const SizedBox(height: 32),
             
             // Bottom Buttons
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 16),
               child: Column(
                 children: [
                   SizedBox(
                     width: double.infinity,
                     height: 48,
                     child: ElevatedButton(
                       onPressed: () {
                         // Action logic here
                       },
                       style: ElevatedButton.styleFrom(
                         backgroundColor: const Color(0xFF0A3D2F),
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                       ),
                       child: const Text('Buka Aplikasi Seabank', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                     ),
                   ),
                   const SizedBox(height: 12),
                   SizedBox(
                     width: double.infinity,
                     height: 48,
                     child: OutlinedButton(
                       onPressed: () {
                         // Actually complete payment flow
                         Provider.of<CartProvider>(context, listen: false).clearCart();
                         Navigator.pushNamed(context, AppRoutes.paymentDone);
                       },
                       style: OutlinedButton.styleFrom(
                         side: const BorderSide(color: AppColors.green),
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                       ),
                       child: const Text('Saya Sudah Membayar', style: TextStyle(color: AppColors.green, fontWeight: FontWeight.bold)),
                     ),
                   ),
                 ],
               ),
             ),
             const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStepper() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _stepIcon(true), _stepLine(true), _stepIcon(true), _stepLine(false), _stepIcon(false)
        ],
      ),
    );
  }

  Widget _stepIcon(bool active) {
    return Container(
      width: 20, height: 20,
      decoration: BoxDecoration(
        color: active ? AppColors.green : Colors.grey[300],
        shape: BoxShape.circle,
        border: active ? Border.all(color: Colors.white, width: 2) : null,
        boxShadow: active ? [const BoxShadow(color: Colors.black12, blurRadius: 4)] : null,
      ),
      child: active ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
    );
  }

  Widget _stepLine(bool active) {
    return Expanded(child: Container(height: 3, color: active ? AppColors.green : Colors.grey[300]));
  }
}