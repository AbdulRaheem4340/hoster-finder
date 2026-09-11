import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_finder/core/routes/app_routes.dart';
import 'package:hostel_finder/core/utils/app_utils.dart';
import 'package:hostel_finder/core/utils/auth_error_handle.dart';
import 'package:hostel_finder/data/models/user_model.dart';
import 'package:hostel_finder/services/auth_service.dart';
import 'package:hostel_finder/services/firestore_service.dart';

class StudentAuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final FirestoreService _firestoreService = Get.find<FirestoreService>();

  final RxBool isLoading = false.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  
  Future<void> login() async {
    //  Validate fields
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      AppUtils.showError("Please fill all fields");
      return;
    }

    try {
      isLoading.value = true;

      
      final credential = await _authService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      //  Fetch user role from Firestore
      final userData = await _firestoreService.getUserData(
        credential.user!.uid,
      );

      if (userData == null) {
        AppUtils.showError("Account setup incomplete. Contact support.");
        return;
      }

      //  Route based on role
      if (userData.role == 'admin') {
        Get.offAllNamed(AppRoutes.adminDashboard);
      } else if (userData.role == 'owner') {
        Get.offAllNamed(AppRoutes.ownerDashboard);
      } else {
        Get.offAllNamed(AppRoutes.studentHome);
      }
    } catch (e) {
      AppUtils.showError(AuthErrorHandler.getMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  ///  Register a new student account.
  Future<void> register() async {
    //  Validate fields
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      AppUtils.showError("Please fill all fields");
      return;
    }

    if (passwordController.text.length < 6) {
      AppUtils.showError("Password must be at least 6 characters");
      return;
    }

    try {
      isLoading.value = true;

      final credential = await _authService.register(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      UserModel newUser = UserModel(
        uid: credential.user!.uid,
        fullName: nameController.text.trim(),
        email: emailController.text.trim(),
        role: 'student',
        createdAt: DateTime.now(),
      );

      await _firestoreService.saveUser(newUser);

      Get.offAllNamed(AppRoutes.studentHome);
      AppUtils.showSuccess("Welcome to Hostel Finder!");
    } catch (e) {
      AppUtils.showError(AuthErrorHandler.getMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.onClose();
  }
}
