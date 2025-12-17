import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Syarat & Ketentuan', style: GoogleFonts.inter(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Syarat & Ketentuan Penggunaan", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(
              "Selamat datang di aplikasi Ayo Tani. Dengan menggunakan aplikasi ini, Anda setuju untuk mematuhi syarat dan ketentuan berikut:\n\n"
              "1. Privasi Data\n"
              "Kami menjaga kerahasiaan data pribadi Anda. Informasi yang Anda berikan hanya digunakan untuk keperluan layanan aplikasi.\n\n"
              "2. Penggunaan Layanan\n"
              "Aplikasi ini digunakan untuk memantau lahan dan edukasi pertanian. Dilarang menyalahgunakan fitur untuk kegiatan ilegal.\n\n"
              "3. Keamanan Akun\n"
              "Anda bertanggung jawab penuh atas keamanan password akun Anda. Jangan bagikan password kepada orang lain.\n\n"
              "4. Perubahan Layanan\n"
              "Kami berhak mengubah atau menghentikan layanan sewaktu-waktu tanpa pemberitahuan sebelumnya untuk keperluan maintenance.\n\n"
              "Hubungi layanan pelanggan jika ada pertanyaan lebih lanjut.",
              style: GoogleFonts.inter(fontSize: 14, height: 1.6, color: Colors.grey[800]),
            ),
          ],
        ),
      ),
    );
  }
}