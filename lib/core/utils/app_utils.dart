import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';

class AppUtils {
  AppUtils._();

  // ===== SNACKBARS =====
  static void showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: AppColors.success,
      colorText: AppColors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  static void showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: AppColors.error,
      colorText: AppColors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  static void showWarning(String message) {
    Get.snackbar(
      'Warning',
      message,
      backgroundColor: AppColors.warning,
      colorText: AppColors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.warning_amber, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  static void showInfo(String message) {
    Get.snackbar(
      'Info',
      message,
      backgroundColor: AppColors.info,
      colorText: AppColors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.info_outline, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  // ===== LOADING DIALOG =====
  static void showLoading({String message = 'Please wait...'}) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                color: AppColors.primary,
              ),
              const SizedBox(width: 16),
              Text(
                message,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void hideLoading() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  // ===== FORMAT =====
  static String formatRent(double amount) {
    return 'PKR ${amount.toStringAsFixed(0)}';
  }
}