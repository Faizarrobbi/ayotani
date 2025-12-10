import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/land_model.dart';
import '../../services/land_service.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';

class AddLandScreen extends StatefulWidget {
  const AddLandScreen({super.key});

  @override
  State<AddLandScreen> createState() => _AddLandScreenState();
}

class _AddLandScreenState extends State<AddLandScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Form State - Clean, no dummy text
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(); 
  final _locationController = TextEditingController(); // Populated by Step 2
  
  // Dropdown Values
  String? _selectedPlantType;
  String? _selectedHarvestTarget;
  
  // Dates
  DateTime? _plantingDate;
  DateTime? _harvestDate;
  
  bool _isLoading = false;

  // Options
  final List<String> _plantTypes = ['Tomat', 'Cabai', 'Padi', 'Jagung', 'Bawang Merah'];
  final List<String> _harvestTargets = ['1 Ton', '2 Ton', '5 Ton', '10 Ton'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: _currentPage > 0 
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300), 
                  curve: Curves.easeInOut
                );
              },
            )
          : IconButton(
              icon: const Icon(Icons.close, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
        title: _currentPage == 2 
            ? const Text('Siapkan Pertanian Anda', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
            : null,
        centerTitle: true,
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) => setState(() => _currentPage = index),
        children: [
          _buildIntroStep(),
          _buildLocationStep(),
          _buildFormStep(),
        ],
      ),
    );
  }

  // STEP 1: Intro (Same visual, just logic check)
  Widget _buildIntroStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1625246333195-58197bd47d72?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text('Ayo Mulai Bertani', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          const Text('Halo Petani, ayo mulai bertani bersama-sama.\nSebelum kita mulai, atur dulu lahan pertanianmu.', style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5), textAlign: TextAlign.center),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0A3D2F), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
              child: const Text('Lanjut', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // STEP 2: Location
  Widget _buildLocationStep() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Container(
            width: 120, height: 120,
            decoration: BoxDecoration(color: Colors.green[50], shape: BoxShape.circle),
            child: const Icon(Icons.location_on_outlined, size: 60, color: Color(0xFF0A3D2F)),
          ),
          const SizedBox(height: 32),
          const Text('Akses Lokasi', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text('Izinkan kami mengakses lokasi anda agar kami dapat memberikan hasil monitoring yang akurat.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, height: 1.5)),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // Simulate fetching GPS location
                setState(() {
                  _locationController.text = "Surabaya, Jawa Timur";
                });
                _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0A3D2F), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
              child: const Text('Izinkan akses lokasi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // STEP 3: Form
  Widget _buildFormStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Nama Pertanian'),
            TextFormField(
              controller: _nameController,
              decoration: _inputDecoration('Contoh: Lahan Tomat Blok A'),
              validator: (v) => v!.isEmpty ? 'Nama lahan wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            
            _buildLabel('Lokasi'),
            TextFormField(
              controller: _locationController,
              // Allow editing if GPS was wrong
              decoration: _inputDecoration('Lokasi lahan').copyWith(suffixIcon: const Icon(Icons.location_on, color: AppColors.green)),
              validator: (v) => v!.isEmpty ? 'Lokasi wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            
            _buildLabel('Tipe Pertanian'),
            _buildDropdown(
              hint: 'Pilih tanaman',
              value: _selectedPlantType,
              items: _plantTypes,
              onChanged: (val) => setState(() => _selectedPlantType = val),
            ),
            const SizedBox(height: 16),
            
            _buildLabel('Tanggal Tanam'),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context, 
                  initialDate: DateTime.now(), 
                  firstDate: DateTime(2020), 
                  lastDate: DateTime(2030)
                );
                if (date != null) setState(() => _plantingDate = date);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _plantingDate == null 
                        ? 'Pilih tanggal tanam' 
                        : '${_plantingDate!.day}/${_plantingDate!.month}/${_plantingDate!.year}',
                      style: TextStyle(color: _plantingDate == null ? Colors.grey[400] : Colors.black),
                    ),
                    const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            _buildLabel('Target Panen'),
            _buildDropdown(
              hint: 'Pilih target',
              value: _selectedHarvestTarget,
              items: _harvestTargets,
              onChanged: (val) => setState(() => _selectedHarvestTarget = val),
            ),
            const SizedBox(height: 16),
            
            _buildLabel('Perkiraan Panen'),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context, 
                  initialDate: DateTime.now().add(const Duration(days: 90)), 
                  firstDate: DateTime(2020), 
                  lastDate: DateTime(2030)
                );
                if (date != null) setState(() => _harvestDate = date);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _harvestDate == null 
                        ? 'Pilih tanggal panen' 
                        : '${_harvestDate!.day}/${_harvestDate!.month}/${_harvestDate!.year}',
                      style: TextStyle(color: _harvestDate == null ? Colors.grey[400] : Colors.black),
                    ),
                    const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A3D2F),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text('Selesaikan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
    );
  }

  Widget _buildDropdown({
    required String hint, 
    required String? value, 
    required List<String> items, 
    required Function(String?) onChanged
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(hint, style: TextStyle(color: Colors.grey[400], fontSize: 14)),
          value: value,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          icon: const Icon(Icons.keyboard_arrow_down),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPlantType == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih tipe pertanian')));
      return;
    }
    
    setState(() => _isLoading = true);
    
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final userId = auth.userProfile?.id;

    if (userId != null) {
      final land = Land(
        id: 0,
        userId: userId,
        name: _nameController.text,
        location: _locationController.text,
        plantType: _selectedPlantType,
        plantingDate: _plantingDate ?? DateTime.now(),
        harvestDate: _harvestDate,
        areaSize: 12.0, // Should typically be an input field too, but using default per UI design
      );

      final success = await LandService().addLand(land);
      
      if (mounted) {
        setState(() => _isLoading = false);
        if (success) {
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal menambahkan lahan')));
        }
      }
    } else {
       await Future.delayed(const Duration(seconds: 1));
       if (mounted) Navigator.pop(context, true);
    }
  }
}