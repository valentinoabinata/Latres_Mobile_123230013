import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          children: [
            const SizedBox(height: 24),
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[800],
              child: const Icon(Icons.person, size: 70, color: Colors.white70),
            ),
            const SizedBox(height: 20),
            // Username reaktif dari controller
            Obx(() => Text(
                  authController.username.value.isNotEmpty
                      ? authController.username.value
                      : 'User',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )),
            const SizedBox(height: 16),
            Text(
              'Kesan: Praktikum Teknologi dan Pemrograman Mobile sangat seru dan berkesan! Belajar Flutter dari nol sampai bisa membangun aplikasi yang fungsional merupakan pengalaman yang sangat berharga dan menyenangkan.',
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Pesan: Semoga ke depannya materi praktikum terus diperbarui mengikuti perkembangan teknologi mobile terkini. Namun, ini hanyalah pesan dari saya yang tidak berarti, terima kasih banyak untuk semua ilmu yang sudah diberikan selama praktikum ini!',
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                // Dialog konfirmasi sebelum logout
                onPressed: () => Get.defaultDialog(
                  title: 'Logout',
                  titleStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  middleText: 'Yakin ingin keluar dari akun ini?',
                  middleTextStyle: const TextStyle(color: Colors.grey),
                  backgroundColor: const Color(0xFF1A1A1A),
                  radius: 12,
                  textConfirm: 'Logout',
                  textCancel: 'Batal',
                  confirmTextColor: Colors.white,
                  cancelTextColor: Colors.grey,
                  buttonColor: Colors.red,
                  onConfirm: authController.logout,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
