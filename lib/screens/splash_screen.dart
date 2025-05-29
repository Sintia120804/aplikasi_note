import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Capture your ideas, anytime, anywhere",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 40),

            // ✅ Perbaiki path gambar di sini
            Image.asset('gambar/yaa.png', height: 250),



            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                "You can quickly jot down your thoughts, ideas, and to-dos, and access them from any device.",
                textAlign: TextAlign.center,
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white24,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: const Text("Get Started", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
