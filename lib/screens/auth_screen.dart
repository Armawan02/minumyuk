import 'package:flutter/material.dart';
import '../services/api_service.dart'; // Panggil service otentikasi

// --------------------------------------------------------------------------
// AUTH SCREEN (Container untuk Login & Register)
// --------------------------------------------------------------------------

class AuthScreen extends StatefulWidget {
  final Function(int) onLoginSuccess;
  const AuthScreen({required this.onLoginSuccess, super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Login' : 'Registrasi')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isLogin ? 'Selamat Datang Kembali' : 'Buat Akun Baru',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              isLogin
                  ? LoginScreen(onLoginSuccess: widget.onLoginSuccess)
                  : RegisterScreen(
                      onRegistrationSuccess: () {
                        setState(() {
                          isLogin =
                              true; // Langsung pindah ke Login setelah sukses daftar
                        });
                      },
                    ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
                child: Text(
                  isLogin
                      ? 'Belum punya akun? Daftar di sini'
                      : 'Sudah punya akun? Masuk',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------------------------------
// FORM LOGIN
// --------------------------------------------------------------------------

class LoginScreen extends StatefulWidget {
  final Function(int) onLoginSuccess;
  const LoginScreen({required this.onLoginSuccess, super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _submitLogin() async {
    setState(() => _isLoading = true);
    final username = _usernameController.text;
    final password = _passwordController.text;

    try {
      final response = await AuthService.login(username, password);

      if (response['success'] == true) {
        widget.onLoginSuccess(
          response['user_id'],
        ); // Panggil fungsi utama untuk simpan sesi
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Gagal Login.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Koneksi Gagal. Pastikan Laragon menyala.'),
        ),
      );
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _usernameController,
          decoration: const InputDecoration(labelText: 'Username'),
        ),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
        const SizedBox(height: 20),
        _isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _submitLogin,
                child: const Text('MASUK'),
              ),
      ],
    );
  }
}

// --------------------------------------------------------------------------
// FORM REGISTRASI
// --------------------------------------------------------------------------

class RegisterScreen extends StatefulWidget {
  final VoidCallback onRegistrationSuccess;
  const RegisterScreen({required this.onRegistrationSuccess, super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _submitRegister() async {
    setState(() => _isLoading = true);
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password minimal 6 karakter.')),
      );
      setState(() => _isLoading = false);
      return;
    }

    try {
      final response = await AuthService.register(username, password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Registrasi Gagal.')),
      );
      if (response['success'] == true) {
        // Jika sukses daftar, panggil callback untuk pindah ke halaman login
        widget.onRegistrationSuccess();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Koneksi Gagal. Pastikan Laragon menyala.'),
        ),
      );
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _usernameController,
          decoration: const InputDecoration(labelText: 'Username'),
        ),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
        const SizedBox(height: 20),
        _isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _submitRegister,
                child: const Text('DAFTAR'),
              ),
      ],
    );
  }
}
