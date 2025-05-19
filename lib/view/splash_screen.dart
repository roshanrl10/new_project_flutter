import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            // Replace with your own image asset
            Image(
              image: AssetImage('assets/images/b.jpeg'),
              width: 150,
              height: 150,
            ),
            SizedBox(height: 20),
            Text("T-REK❤️", style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
