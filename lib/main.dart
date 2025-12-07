import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import file-file yang baru Anda buat
import 'screens/auth_screen.dart';
import 'screens/water_tracker_screen.dart';

// --------------------------------------------------------------------------
// FILE INI HANYA UNTUK SESSION CHECK DAN INITIALISASI
// --------------------------------------------------------------------------

void main() {
  runApp(const MinumYukApp());
}

class MinumYukApp extends StatefulWidget {
  const MinumYukApp({super.key});

  @override
  State<MinumYukApp> createState() => _MinumYukAppState();
}

class _MinumYukAppState extends State<MinumYukApp> {
  int? _currentUserId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  // Cek apakah ada user_id yang tersimpan di memori HP
  // Lokasi: _MinumYukAppState di main.dart
  Future<void> _checkSession() async {
    print('DEBUG AMBIL: Memulai pengecekan sesi...');
    final prefs = await SharedPreferences.getInstance();
    final storedId = prefs.getInt('current_user_id');

    print(
      'DEBUG AMBIL: ID yang diambil dari memori HP: $storedId',
    ); // <-- TAMBAH INI

    if (storedId != null) {
      setState(() {
        _currentUserId = storedId;
        _isLoading = false;
      });
      print('DEBUG AMBIL: Sesi Ditemukan. Langsung ke WaterTrackerScreen.');
    } else {
      setState(() {
        _isLoading = false;
      });
      print('DEBUG AMBIL: Sesi TIDAK Ditemukan. Menampilkan AuthScreen.');
    }
  }

  // Fungsi untuk update state setelah login/logout
  // Lokasi: _MinumYukAppState di main.dart
  // Lokasi: _MinumYukAppState di lib/main.dart

  void _updateUserSession(int? userId) async {
    final prefs = await SharedPreferences.getInstance();

    if (userId != null) {
      // 1. Tulis ID dan JANGAN LUPA AWAIT!
      await prefs.setInt('user_id', userId);

      // 2. DEBUG KRUSIAL: Baca kembali ID segera setelah disimpan
      final checkBack = prefs.getInt('user_id');

      print('DEBUG SIMPAN: ID PENGGUNA BARU berhasil disimpan: $userId');
      print(
        'DEBUG SIMPAN: CHECK BALIK: Apakah ID baru terbaca? $checkBack',
      ); // <-- LIHAT OUTPUT INI
    } else {
      prefs.remove('user_id');
      print('DEBUG SIMPAN: Sesi dihapus (Logout).');
    }
    setState(() {
      _currentUserId = userId;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MinumYuk Pro',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: _currentUserId != null
          ? WaterTrackerScreen(
              userId: _currentUserId!,
              onLogout: () => _updateUserSession(null),
            )
          : AuthScreen(onLoginSuccess: (id) => _updateUserSession(id)),
    );
  }
}
