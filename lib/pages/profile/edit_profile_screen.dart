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
    // Ambil data user
    final userProfile = Provider.of<AuthProvider>(context, listen: false).userProfile;
    final currentUser = Supabase.instance.client.auth.currentUser;
    
    _nameController.text = userProfile?.username ?? '';
    _emailController.text = currentUser?.email ?? '';
  }

  Future<void> _updateProfile() async {
    setState(() => _isLoading = true);
    try {
      final supabase = Supabase.instance.client;
      final newEmail = _emailController.text.trim();

      // Hanya update Email karena Nama & Gambar di-lock (read-only)
      if (newEmail.isNotEmpty && newEmail != supabase.auth.currentUser?.email) {
        await supabase.auth.updateUser(UserAttributes(email: newEmail));
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email diperbarui! Cek inbox email baru Anda untuk konfirmasi.')),
          );
           Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak ada perubahan yang disimpan.')),
          );
        }
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
    // Ambil URL avatar untuk ditampilkan
    final userProfile = Provider.of<AuthProvider>(context).userProfile;
    final avatarUrl = userProfile?.avatarUrl;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Profil Saya', style: GoogleFonts.inter(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // --- 1. Tampilan Gambar (Read Only) ---
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[200],
                backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                    ? NetworkImage(avatarUrl)
                    : null,
                child: (avatarUrl == null || avatarUrl.isEmpty)
                    ? Icon(Icons.person, size: 50, color: Colors.grey[400])
                    : null,
              ),
            ),
            const SizedBox(height: 30),

            // --- 2. Nama (Read Only / Locked) ---
            _buildTextField(
              "Nama Lengkap", 
              _nameController, 
              Icons.person, 
              isReadOnly: true // Dikunci
            ),
            const SizedBox(height: 20),

            // --- 3. Email (Bisa Diedit) ---
            _buildTextField(
              "Email", 
              _emailController, 
              Icons.email,
              isReadOnly: false // Bisa diubah
            ),
            
            const SizedBox(height: 40),

            // --- 4. Tombol Simpan ---
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
                    : Text("Simpan Perubahan Email", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {required bool isReadOnly}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: isReadOnly, // Kunci field jika readOnly true
          style: TextStyle(color: isReadOnly ? Colors.grey[600] : Colors.black),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: isReadOnly ? Colors.grey : Colors.black54),
            filled: isReadOnly,
            fillColor: isReadOnly ? Colors.grey[100] : Colors.white, // Warna abu jika dikunci
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isReadOnly ? Colors.transparent : Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isReadOnly ? Colors.transparent : AppColors.green, width: 2),
            ),
          ),
        ),
        if (isReadOnly)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              "*Nama tidak dapat diubah.",
              style: GoogleFonts.inter(fontSize: 10, color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ),
      ],
    );
  }
}