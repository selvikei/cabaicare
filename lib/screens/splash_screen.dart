import 'dart:async';
import 'package:flutter/material.dart';
import '../screens/home_page.dart'; // Pastikan path import HomePage kamu benar

class CustomSplashScreen extends StatefulWidget {
  const CustomSplashScreen({super.key});

  @override
  State<CustomSplashScreen> createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen> {
  @override
  void initState() {
    super.initState();
    // Mengatur delay 3 detik sebelum pindah ke HomePage
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9EFEF), // Warna hijau gelap CabaiCare
      body: Stack(
        children: [
          // 1. Logo Aplikasi di Tengah Layar
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/cabaicare.png',
                  width: 140,
                  height: 140,
                ),
                const SizedBox(height: 20),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              ],
            ),
          ),
          
          // 2. Teks Copyright Murni Code di Bagian Bawah
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "© 2026 Selvi - Politeknik Elektronika Negeri Surabaya",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.black.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "CabaiCare Team • PENS",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}