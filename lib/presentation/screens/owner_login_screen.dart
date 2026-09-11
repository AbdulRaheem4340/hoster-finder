import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_finder/core/constants/app_colors.dart';
import 'package:hostel_finder/core/routes/app_routes.dart';
import 'package:hostel_finder/presentation/controllers/owner_auth_controller.dart';

class OwnerLoginScreen extends StatelessWidget {
  const OwnerLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OwnerAuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Owner Login")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Icon(
                Icons.admin_panel_settings_rounded,
                size: 80,
                color: AppColors.secondary,
              ),
              const SizedBox(height: 30),
              TextField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: "Owner Email",
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: controller.passwordController,
                obscureText: true,
                onSubmitted: (value) => controller.login(),
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                        ),
                        child: const Text("Owner Login"),
                      ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Get.toNamed(AppRoutes.ownerRegister),
                child: const Text("Become an authorized owner? Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
