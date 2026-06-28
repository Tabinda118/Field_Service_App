import 'package:field_service_app/services/auth_services.dart';
import 'package:field_service_app/views/auth/forgot_password_screen.dart';
import 'package:field_service_app/views/auth/signup_screen.dart';
import 'package:field_service_app/views/dashboard/dashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isHidden = true.obs;
  final isLoading = false.obs;
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 35),

              const Text(
                "FIELD SERVICE APP",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Manage Jobs • Track Progress • Stay Connected",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 40),

              const Text(
                "Welcome Back, Technician 👷‍♂️",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Login to manage your assigned service jobs and updates.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 30),

              // EMAIL
              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  labelText: "Email Address",
                  prefixIcon: const Icon(Icons.email_outlined,
                      color: Colors.deepPurple),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // PASSWORD
              Obx(
                    () => TextField(
                  controller: passwordController,
                  obscureText: isHidden.value,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock_outline,
                        color: Colors.deepPurple),
                    suffixIcon: IconButton(
                      onPressed: () {
                        isHidden.value = !isHidden.value;
                      },
                      icon: Icon(
                        isHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Get.to(() => ForgotPasswordScreen());
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Colors.purple,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // LOGIN BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Obx(
                      () => ElevatedButton(
                    onPressed: isLoading.value
                        ? null
                        : () async {
                      if (emailController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        Get.snackbar(
                          "Error",
                          "Please enter email and password",
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }
                      //Email Validation(check kay ager user khali chor dai fields to msg yeh ho ga)

                      if (!GetUtils.isEmail(
                          emailController.text.trim())) {
                        Get.snackbar(
                          "Error",
                          "Please enter a valid email",
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }

                      try {
                        isLoading.value = true;

                        final user = await authService.login(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );

                        isLoading.value = false;

                        if (user != null) {
                          //print("LOGIN BUTTON PRESSED");
                          //print("UID: ${user.uid}");
                          Get.snackbar(
                            "Success",
                            "Login successful",
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );

                          Get.offAll(() => const DashboardScreen());
                        }
                      }
                      catch (e) {
                        isLoading.value = false;

                        String errorMessage = e.toString();

                        if (errorMessage.contains('network') ||
                            errorMessage.contains('Network')) {
                          errorMessage =
                          "No internet connection. Please try again.";
                        }

                        Get.snackbar(
                          "Error",
                          errorMessage,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: isLoading.value
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text(
                      "LOGIN TO YOUR ACCOUNT",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // SIGNUP
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Get.to(() => SignupScreen());
                    },
                    child: const Text("Create Account"),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}