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
  Future<void> _checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    final storedId = prefs.getInt('user_id');

    if (storedId != null) {
      setState(() {
        _currentUserId = storedId;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fungsi untuk update state setelah login/logout
  void _updateUserSession(int? userId) async {
    final prefs = await SharedPreferences.getInstance();
    if (userId != null) {
      prefs.setInt('user_id', userId);
    } else {
      prefs.remove('user_id'); // Logout
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
