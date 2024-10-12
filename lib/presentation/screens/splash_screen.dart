import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5), //#FFE5E5E5,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/splash_logo.png', height: 150, width: 150),
            const SizedBox(height: 20),
            const CircularProgressIndicator(), // Loader while initializing the app
          ],
        ),
      ),
    );
  }
}
