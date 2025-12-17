import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Isi form dengan data saat ini
    final userProfile = Provider.of<AuthProvider>(context, listen: false).userProfile;
    final currentUser = Supabase.instance.client.auth.currentUser;
    
    _nameController.text = userProfile?.username ?? '';
    _emailController.text = currentUser?.email ?? '';
  }

  Future<void> _updateProfile() async {
    setState(() => _isLoading = true);
    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser!.id;
      final newName = _nameController.text.trim();
      final newEmail = _emailController.text.trim();

      // 1. Update Nama di tabel 'profiles'
      if (newName.isNotEmpty) {
        await supabase
            .from('profiles')
            .update({'username': newName})
            .eq('user_id', userId);
      }

      // 2. Update Email di Auth (Jika berubah)
      // CATATAN: Supabase biasanya mengirim email konfirmasi ke email baru 
      // sebelum perubahan efektif, tergantung settingan di dashboard Supabase Anda.
      if (newEmail.isNotEmpty && newEmail != supabase.auth.currentUser?.email) {
        await supabase.auth.updateUser(UserAttributes(email: newEmail));
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email diperbarui! Silakan cek inbox email baru Anda untuk konfirmasi.')),
          );
        }
      }

      // 3. Refresh data di aplikasi agar UI berubah
      if (mounted) {
        await Provider.of<AuthProvider>(context, listen: false).loadUserProfile();
        Navigator.pop(context); // Kembali ke menu profil
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil diperbarui')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal update: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Edit Profil', style: GoogleFonts.inter(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildTextField("Nama Lengkap", _nameController, Icons.person),
            const SizedBox(height: 20),
            _buildTextField("Email", _emailController, Icons.email),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text("Simpan Perubahan", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.green, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}