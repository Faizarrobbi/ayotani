import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data Dummy
    final notifs = [
      {'title': 'Panen berhasil dicatat!', 'time': '2 jam yang lalu', 'read': false},
      {'title': 'Harga Pupuk Urea turun', 'time': '5 jam yang lalu', 'read': true},
      {'title': 'Peringatan cuaca ekstrem besok', 'time': '1 hari yang lalu', 'read': true},
      {'title': 'Selamat datang di Ayo Tani', 'time': '3 hari yang lalu', 'read': true},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Notifikasi', style: GoogleFonts.inter(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifs.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final item = notifs[index];
          final isRead = item['read'] as bool;
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: isRead ? Colors.grey[200] : AppColors.green.withOpacity(0.1),
              child: Icon(Icons.notifications, color: isRead ? Colors.grey : AppColors.green),
            ),
            title: Text(
              item['title'] as String,
              style: GoogleFonts.inter(fontWeight: isRead ? FontWeight.normal : FontWeight.bold),
            ),
            subtitle: Text(item['time'] as String),
            trailing: isRead ? null : const Icon(Icons.circle, size: 10, color: Colors.red),
          );
        },
      ),
    );
  }
}