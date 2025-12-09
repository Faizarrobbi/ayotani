import 'package:flutter/material.dart';

// Model untuk Payment Method
class PaymentMethod {
  final String id;
  final String name;
  final String? subtitle;
  final String? logo;
  final IconData? icon;
  final PaymentType type;

  PaymentMethod({
    required this.id,
    required this.name,
    this.subtitle,
    this.logo,
    this.icon,
    required this.type,
  });
}

enum PaymentType {
  general,
  ewallet,
  bankTransfer,
}

class PaymentMethodScreen extends StatefulWidget {
  final double totalAmount;
  final String? selectedPaymentId;

  const PaymentMethodScreen({
    Key? key,
    this.totalAmount = 402000,
    this.selectedPaymentId,
  }) : super(key: key);

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String? selectedPaymentId;

  final List<PaymentMethod> generalMethods = [
    PaymentMethod(
      id: 'saldo',
      name: 'Saldo',
      subtitle: '(Rp128.000)',
      icon: Icons.account_balance_wallet,
      type: PaymentType.general,
    ),
    PaymentMethod(
      id: 'cod',
      name: 'Bayar di Tempat',
      icon: Icons.inventory_2_outlined,
      type: PaymentType.general,
    ),
    PaymentMethod(
      id: 'credit_card',
      name: 'Kartu Kredit/Debit',
      icon: Icons.credit_card,
      type: PaymentType.general,
    ),
  ];

  final List<PaymentMethod> ewalletMethods = [
    PaymentMethod(
      id: 'gopay',
      name: 'GoPay',
      logo: 'assets/images/gopay_logo.png',
      type: PaymentType.ewallet,
    ),
    PaymentMethod(
      id: 'dana',
      name: 'DANA',
      logo: 'assets/images/dana_logo.png',
      type: PaymentType.ewallet,
    ),
  ];

  final List<PaymentMethod> bankTransferMethods = [
    PaymentMethod(
      id: 'bri',
      name: 'Bank BRI',
      logo: 'assets/images/bri_logo.png',
      type: PaymentType.bankTransfer,
    ),
    PaymentMethod(
      id: 'bni',
      name: 'Bank BNI',
      logo: 'assets/images/bni_logo.png',
      type: PaymentType.bankTransfer,
    ),
    PaymentMethod(
      id: 'bca',
      name: 'Bank BCA',
      logo: 'assets/images/bca_logo.png',
      type: PaymentType.bankTransfer,
    ),
    PaymentMethod(
      id: 'bsi',
      name: 'Bank Syariah Indonesia',
      logo: 'assets/images/bsi_logo.png',
      type: PaymentType.bankTransfer,
    ),
  ];

  @override
  void initState() {
    super.initState();
    selectedPaymentId = widget.selectedPaymentId;
  }

  void selectPayment(String paymentId) {
    setState(() {
      selectedPaymentId = paymentId;
    });
  }

  void confirmSelection() {
    if (selectedPaymentId != null) {
      PaymentMethod? selected;
      
      for (var method in [...generalMethods, ...ewalletMethods, ...bankTransferMethods]) {
        if (method.id == selectedPaymentId) {
          selected = method;
          break;
        }
      }

      Navigator.pop(context, {
        'paymentId': selectedPaymentId,
        'paymentName': selected?.name ?? '',
      });
    }
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
          'Pilih Pembayaran',
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  ...generalMethods.map((method) => _buildPaymentOption(method)).toList(),
                  
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
                    child: Text(
                      'E-wallet',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ...ewalletMethods.map((method) => _buildPaymentOption(method)).toList(),
                  
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
                    child: Text(
                      'Transfer Bank',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ...bankTransferMethods.map((method) => _buildPaymentOption(method)).toList(),
                  
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildPaymentOption(PaymentMethod method) {
    final isSelected = selectedPaymentId == method.id;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? const Color(0xFF2D6A4F) : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () => selectPayment(method.id),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (method.logo != null)
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: _buildPaymentLogo(method),
                  ),
                )
              else if (method.icon != null)
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    method.icon,
                    color: const Color(0xFF2D6A4F),
                    size: 24,
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (method.subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        method.subtitle!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected 
                        ? const Color(0xFF2D6A4F) 
                        : const Color(0xFFD9D9D9),
                    width: 2,
                  ),
                  color: Colors.white,
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF2D6A4F),
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentLogo(PaymentMethod method) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      child: _getLogoWidget(method.id),
    );
  }

  Widget _getLogoWidget(String id) {
    Color logoColor;
    String text;
    
    switch (id) {
      case 'gopay':
        logoColor = const Color(0xFF00AA13);
        text = 'GP';
        break;
      case 'dana':
        logoColor = const Color(0xFF118EEA);
        text = 'DA';
        break;
      case 'bri':
        logoColor = const Color(0xFF003d7a);
        text = 'BRI';
        break;
      case 'bni':
        logoColor = const Color(0xFFf37021);
        text = 'BNI';
        break;
      case 'bca':
        logoColor = const Color(0xFF003d7a);
        text = 'BCA';
        break;
      case 'bsi':
        logoColor = const Color(0xFF00a651);
        text = 'BSI';
        break;
      default:
        logoColor = Colors.grey;
        text = '?';
    }
    
    return Container(
      decoration: BoxDecoration(
        color: logoColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: logoColor,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Rp${widget.totalAmount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D6A4F),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: selectedPaymentId != null ? confirmSelection : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedPaymentId != null
                        ? const Color(0xFF2D6A4F)
                        : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    disabledBackgroundColor: Colors.grey,
                  ),
                  child: const Text(
                    'Pilih',
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