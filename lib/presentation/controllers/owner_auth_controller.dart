import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_finder/core/routes/app_routes.dart';
import 'package:hostel_finder/core/utils/app_utils.dart';
import 'package:hostel_finder/core/utils/auth_error_handle.dart';
import 'package:hostel_finder/data/models/user_model.dart';
import 'package:hostel_finder/services/auth_service.dart';
import 'package:hostel_finder/services/firestore_service.dart';

class OwnerAuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final FirestoreService _firestoreService = Get.find<FirestoreService>();

  final RxBool isLoading = false.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final secretKeyController = TextEditingController();

  final String _systemSecretKey = "1122";

  //  Centralized field validation
  String? _validateEmailAndPassword() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      return "Please fill all fields";
    }

    //  Basic email format check
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return "Please enter a valid email address (e.g. user@gmail.com)";
    }

    //  Password length check BEFORE calling Firebase
    if (password.length < 6) {
      return "Password must be at least 6 characters";
    }

    return null;
  }

  Future<void> login() async {
    //  Validate locally first
    final validationError = _validateEmailAndPassword();
    if (validationError != null) {
      AppUtils.showError(validationError);
      return;
    }

    try {
      isLoading.value = true;

      final credential = await _authService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      final userData = await _firestoreService.getUserData(
        credential.user!.uid,
      );

      if (userData == null) {
        //  User authenticated but no Firestore record found
        AppUtils.showError(
          "Account data not found. Please register first.",
        );
        await _authService.logout();
        return;
      }

      //  Role-based navigation
      if (userData.role == 'owner') {
        Get.offAllNamed(AppRoutes.ownerDashboard);
      } else if (userData.role == 'admin') {
        Get.offAllNamed(AppRoutes.adminDashboard);
      } else {
        AppUtils.showError(
          "You are not registered as an Owner. Please use the correct login.",
        );
        await _authService.logout();
      }
    } catch (e) {
      AppUtils.showError(AuthErrorHandler.getMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    //  Check secret key first
    if (secretKeyController.text.trim() != _systemSecretKey) {
      AppUtils.showError("Invalid Secret Key. You are not authorized.");
      return;
    }

    //  Check name
    if (nameController.text.trim().isEmpty) {
      AppUtils.showError("Please enter your full name");
      return;
    }

    //  Validate email & password locally
    final validationError = _validateEmailAndPassword();
    if (validationError != null) {
      AppUtils.showError(validationError);
      return;
    }

    try {
      isLoading.value = true;

      //  Always trim before sending to Firebase
      final credential = await _authService.register(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      UserModel newOwner = UserModel(
        uid: credential.user!.uid,
        fullName: nameController.text.trim(),
        email: emailController.text.trim(),
        role: 'owner',
        createdAt: DateTime.now(),
      );

      await _firestoreService.saveUser(newOwner);

      AppUtils.showSuccess("Owner Account Created Successfully ✅");
      Get.offAllNamed(AppRoutes.ownerDashboard);
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
    secretKeyController.dispose();
    super.onClose();
  }
}