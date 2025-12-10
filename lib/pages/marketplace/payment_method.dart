import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({Key? key}) : super(key: key);

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String _selectedId = 'seabank'; // Default selection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Pilih Pembayaran', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOptionGroup([
              _buildOption('saldo', 'Saldo', 'Rp128.000', Icons.account_balance_wallet_outlined),
              _buildOption('cod', 'Bayar di Tempat', null, Icons.inventory_2_outlined),
              _buildOption('cc', 'Kartu Kredit/Debit', null, Icons.credit_card),
            ]),
            
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text('E-wallet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            _buildOptionGroup([
              _buildOption('gopay', 'GoPay', null, Icons.account_balance_wallet, isLogo: true, color: Colors.blue),
              _buildOption('dana', 'DANA', null, Icons.account_balance_wallet, isLogo: true, color: Colors.blueAccent),
            ]),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text('Transfer Bank', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
             _buildOptionGroup([
              _buildOption('bri', 'Bank BRI', null, Icons.house, isLogo: true, color: Colors.blue[900]),
              _buildOption('bni', 'Bank BNI', null, Icons.house, isLogo: true, color: Colors.orange),
              _buildOption('bca', 'Bank BCA', null, Icons.house, isLogo: true, color: Colors.blue),
              _buildOption('bsi', 'Bank Syariah Indonesia', null, Icons.house, isLogo: true, color: Colors.teal),
              _buildOption('seabank', 'Seabank', null, Icons.savings, isLogo: true, color: Colors.orange[700]),
              _buildOption('mandiri', 'Bank Mandiri', null, Icons.house, isLogo: true, color: Colors.yellow[800]),
            ]),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                // Return simple data map
                String name = 'Seabank';
                if (_selectedId == 'gopay') name = 'GoPay';
                if (_selectedId == 'saldo') name = 'Saldo';
                // ... add mapping logic or pass full object
                
                Navigator.pop(context, {'paymentId': _selectedId, 'paymentName': name});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Pilih', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionGroup(List<Widget> children) {
    return Column(children: children);
  }

  Widget _buildOption(String id, String title, String? subtitle, IconData iconData, {bool isLogo = false, Color? color}) {
    bool isSelected = _selectedId == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedId = id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            if (isLogo)
              Icon(iconData, color: color ?? Colors.grey, size: 24) // Placeholder for Logo Image
            else
              Icon(iconData, color: Colors.teal, size: 24),
            
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  if (subtitle != null)
                    Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            
            // Radio Circle
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? AppColors.green : Colors.grey[300]!, width: 2),
              ),
              child: isSelected 
                  ? Center(child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle))) 
                  : null,
            )
          ],
        ),
      ),
    );
  }
}