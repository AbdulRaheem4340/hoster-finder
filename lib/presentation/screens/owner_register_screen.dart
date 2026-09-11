import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_finder/core/constants/app_colors.dart';
import 'package:hostel_finder/presentation/controllers/owner_auth_controller.dart';

class OwnerRegisterScreen extends StatelessWidget {
  const OwnerRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OwnerAuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Owner Registration")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Authorized Registration Only",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: controller.secretKeyController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.visiblePassword,

                decoration: const InputDecoration(
                  labelText: "System Secret Key",
                  prefixIcon: Icon(Icons.vpn_key),
                  hintText: "Enter the key provided by Admin",
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: controller.nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: controller.emailController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,

                decoration: const InputDecoration(
                  labelText: "Email",

                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: controller.passwordController,
                onSubmitted: (value) => controller.register(),

                obscureText: true,
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
                        onPressed: () => controller.register(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                        ),
                        child: const Text("Register as Owner"),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
