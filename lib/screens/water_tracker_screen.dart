import 'package:flutter/material.dart';
import '../services/api_service.dart'; // Panggil service yang baru dibuat

class WaterTrackerScreen extends StatefulWidget {
  final int userId;
  final VoidCallback onLogout;
  const WaterTrackerScreen({
    required this.userId,
    required this.onLogout,
    super.key,
  });

  @override
  State<WaterTrackerScreen> createState() => _WaterTrackerScreenState();
}

class _WaterTrackerScreenState extends State<WaterTrackerScreen> {
  int totalMinum = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _ambilDataDariServer();
  }

  // Fungsi Ambil Data dari PHP (Sekarang memanggil WaterService)
  Future<void> _ambilDataDariServer() async {
    setState(() => isLoading = true);
    try {
      final data = await WaterService.getData(widget.userId);
      setState(() {
        totalMinum = int.parse(data['total'].toString());
      });
    } catch (e) {
      print("Error ambil data: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Fungsi Tambah Air
  void _tambahAir() async {
    setState(() => totalMinum += 250);
    try {
      await WaterService.addWater(widget.userId);
    } catch (e) {
      print("Gagal kirim ke server: $e");
      setState(() => totalMinum -= 250); // Rollback
    }
  }

  // Fungsi Reset
  void _reset() async {
    setState(() => totalMinum = 0);
    try {
      await WaterService.resetWater(widget.userId);
    } catch (e) {
      print("Gagal reset: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text("MinumYuk Akun ID: ${widget.userId}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: widget.onLogout, // Panggil fungsi logout
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.water_drop, size: 80, color: Colors.blue),
                  const SizedBox(height: 20),
                  const Text(
                    "Total Minum Hari Ini:",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "$totalMinum ml",
                    style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _tambahAir,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                    ),
                    child: const Text(
                      'TAMBAH 250ml',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: _reset,
                    child: const Text(
                      'Reset',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
