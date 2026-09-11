import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hostel_finder/core/constants/app_colors.dart';
import 'package:hostel_finder/presentation/controllers/owner_controller.dart';

///  Facility chips
class FacilitySelector extends StatelessWidget {
  const FacilitySelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OwnerController>();
    return Obx(
      () => Wrap(
        spacing: 8,
        children: controller.availableFacilities
            .map(
              (f) => FilterChip(
                label: Text(f),
                selected: controller.selectedFacilities.contains(f),
                onSelected: (val) => controller.toggleFacility(f),
                selectedColor: AppColors.secondary.withValues(alpha: 0.2),
              ),
            )
            .toList(),
      ),
    );
  }
}
