import 'package:field_service_app/services/auth_services.dart';
import 'package:field_service_app/views/dashboard/dashboard_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isHidden = true.obs;
  final AuthService authService = AuthService();
  final isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 40),

              const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Register to start managing service jobs",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 30),

              // NAME
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  prefixIcon: Icon(Icons.person, color: Colors.deepPurple),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              // EMAIL
              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email, color: Colors.deepPurple),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              // PHONE
              TextField(
                controller: phoneController,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  prefixIcon: Icon(Icons.phone, color: Colors.deepPurple),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              // PASSWORD
              Obx(
                    () => TextField(
                  controller: passwordController,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  obscureText: isHidden.value,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock, color: Colors.deepPurple),
                    border: const OutlineInputBorder(),
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
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // CONFIRM PASSWORD
              Obx(
                    () => TextField(
                  controller: confirmPasswordController,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  obscureText: isHidden.value,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Colors.deepPurple,
                    ),
                    border: const OutlineInputBorder(),

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
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // SIGNUP BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,
                child: Obx(() => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  onPressed: isLoading.value
                      ? null
                      : () async {
                    if (nameController.text.isEmpty ||
                        emailController.text.isEmpty ||
                        phoneController.text.isEmpty ||
                        passwordController.text.isEmpty ||
                        confirmPasswordController.text.isEmpty) {
                      Get.snackbar(
                        "Error",
                        "Please fill all fields",
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                      return;
                    }

                    if (passwordController.text !=
                        confirmPasswordController.text) {
                      Get.snackbar(
                        "Error",
                        "Passwords do not match",
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                      return;
                    }

                    try {
                      isLoading.value = true;

                      final user = await authService.signUp(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      );

                      if (user != null) {
                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(user.uid)
                            .set({
                          "name": nameController.text.trim(),
                          "email": emailController.text.trim(),
                          "phone": phoneController.text.trim(),
                          "uid": user.uid,
                          "role": "technician",
                        });

                        isLoading.value = false;

                        Get.snackbar(
                          "Success",
                          "Account created successfully",
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
                    "CREATE ACCOUNT",
                    style: TextStyle(color: Colors.white),
                  ),
                )),
              ),

              const SizedBox(height: 15),

              // LOGIN TEXT (UNCHANGED)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text("Login"),
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