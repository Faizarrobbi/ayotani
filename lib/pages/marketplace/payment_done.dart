import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class PaymentDoneScreen extends StatelessWidget {
  const PaymentDoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 0,
        leading: const SizedBox(), // Hide back button
        title: const Text('Checkout', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
         actions: [
          IconButton(icon: const Icon(Icons.headset_mic_outlined, color: AppColors.green), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Stepper
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _stepIcon(true), _stepLine(true), _stepIcon(true), _stepLine(true), _stepIcon(true)
              ],
            ),
          ),
          
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(color: Color(0xFF0A3D2F), shape: BoxShape.circle),
                  child: const Icon(Icons.check, size: 60, color: Colors.white),
                ),
                const SizedBox(height: 24),
                const Text('Pembayaran Berhasil!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
                const SizedBox(height: 12),
                const Text(
                  'Pesanan Anda telah berhasil dibuat!\nUntuk keterangan lebih lanjut, kunjungi\nkeranjang.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, height: 1.5),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A3D2F),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Lanjut Belanja', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/cart', (route) => false),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.green),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Keranjang Saya', style: TextStyle(color: AppColors.green, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          )
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
      ),
      child: active ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
    );
  }

  Widget _stepLine(bool active) {
    return Expanded(child: Container(height: 3, color: active ? AppColors.green : Colors.grey[300]));
  }
}