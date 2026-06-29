import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'PlusJakartaSans', // Mengunci font sesuai maumu
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
      backgroundColor: const Color(0xFF2E5959), // Warna hijau gelap CabaiCare
      foregroundColor: Colors.white, // Warna teks & tombol default menjadi putih
      elevation: 0,
      // Tombol back otomatis menyesuaikan dengan navigasi halaman
      leading: Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Navigator.pop(context),
            )
          : null,
      actions: actions,
    );
  }

  // Wajib mendefinisikan preferredSize standar AppBar Android (56.0)
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}