import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_finder/core/constants/app_colors.dart';
import 'package:hostel_finder/core/routes/app_routes.dart';
import 'package:hostel_finder/presentation/controllers/student_auth_controller.dart';

class StudentLoginScreen extends StatelessWidget {
  const StudentLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentAuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Student Login")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Icon(
                Icons.school_rounded,
                size: 80,
                color: AppColors.primary,
              ),
              const SizedBox(height: 30),
              TextField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: controller.passwordController,
                obscureText: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => controller.login(),
                decoration: const InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 30),
              Obx(
                () => controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () => controller.login(),
                        child: const Text("Login"),
                      ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Get.toNamed(AppRoutes.studentRegister),
                child: const Text("Don't have an account? Register here"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
