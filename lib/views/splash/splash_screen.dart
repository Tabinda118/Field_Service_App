import 'dart:async';
import 'package:field_service_app/main.dart';
import 'package:field_service_app/views/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      //Replace current screen and open new screen
      Get.off(() => const AuthWrapper());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [

            Icon(
              Icons.build,
              size: 80,
              color: Colors.blue,
            ),

            SizedBox(height: 20),

            Text(
              "Field Service App",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}