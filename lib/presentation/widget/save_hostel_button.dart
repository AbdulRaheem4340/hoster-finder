import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hostel_finder/core/constants/app_colors.dart';
import 'package:hostel_finder/presentation/controllers/owner_controller.dart';

///  Save / Update button
class SaveHostelButton extends StatelessWidget {
  const SaveHostelButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OwnerController>();
    return Obx(
      () => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : ElevatedButton(
              onPressed: () => controller.saveHostel(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                minimumSize: const Size(double.infinity, 55),
              ),
              child: Text(
                controller.editingHostel == null
                    ? "Upload Hostel Info"
                    : "Update Hostel Info",
              ),
            ),
    );
  }
}
