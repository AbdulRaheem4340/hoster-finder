import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_finder/presentation/controllers/student_auth_controller.dart';

class StudentRegisterScreen extends StatelessWidget {
  const StudentRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentAuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Student Registration")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                        child: const Text("Register"),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
