import 'package:flutter/material.dart';
import 'screens/awal/awal_screen.dart'; // Awal screen
import 'screens/home/beranda_screen.dart'; // Beranda
import 'screens/home/sejarah_screen.dart';
// import 'screens/umkm/daftar_umkm_screen.dart';
import 'screens/umkm/register_umkm.dart';
// import 'screens/profile/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LokalMart',
      home: const LokalMartLogin(), // ← Awal screen kamu
      routes: {
        '/beranda': (context) => const BerandaScreen(),
        '/sejarah': (context) => const SejarahSriharjoScreen(),
        '/register': (context) => const RegisterUmkmScreen(),
        // '/umkm': (context) => const DaftarUMKMScreen(),
        // '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
