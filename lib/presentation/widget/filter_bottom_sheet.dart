import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_finder/core/constants/app_colors.dart';
import 'package:hostel_finder/presentation/controllers/student_map_controller.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentMapController>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Filter Hostels",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            //  SORT BY DROPDOWN
            const Text(
              "Sort By",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const SortByDropdown(),

            const SizedBox(height: 20),

            //  PRICE SLIDER
            const Text(
              "Max Monthly Rent (PKR)",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Obx(
              () => Column(
                children: [
                  Slider(
                    value: controller.maxRent.value,
                    min: 2000,
                    max: 25000,
                    divisions: 28,
                    activeColor: AppColors.primary,
                    label: controller.maxRent.value.round().toString(),
                    onChanged: (val) => controller.maxRent.value = val,
                  ),
                  Text(
                    "Under ${controller.maxRent.value.toInt()} PKR",
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            //  FACILITIES
            const Text(
              "Facilities",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children:
                  [
                    "WiFi",
                    "AC",
                    "Laundry",
                    "Solar System",
                    "Mess",
                    "Common Bath",
                  ].map((f) {
                    return Obx(() {
                      bool isSelected = controller.selectedFacilities.contains(
                        f,
                      );
                      return FilterChip(
                        label: Text(f),
                        selected: isSelected,
                        selectedColor: AppColors.primary.withValues(alpha: 0.2),
                        onSelected: (_) => controller.toggleFilterFacility(f),
                      );
                    });
                  }).toList(),
            ),

            const SizedBox(height: 30),

            //  BUTTONS
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => controller.resetFilters(),
                    child: const Text("Reset"),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => controller.applyFilters(),
                    child: const Text("Apply Filters"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

///  Dropdown for selecting sort order.
class SortByDropdown extends StatelessWidget {
  const SortByDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentMapController>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Obx(
        () => DropdownButton<String>(
          value: controller.selectedSortType.value,
          isExpanded: true,
          underline: const SizedBox.shrink(),
          items: const [
            DropdownMenuItem(
              value: 'default',
              child: Row(
                children: [
                  Icon(Icons.sort, size: 18, color: Colors.grey),
                  SizedBox(width: 8),
                  Text("Default Order"),
                ],
              ),
            ),
            DropdownMenuItem(
              value: 'distance',
              child: Row(
                children: [
                  Icon(Icons.near_me, size: 18, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text("Nearest First"),
                ],
              ),
            ),
          ],

          onChanged: (newValue) {
            if (newValue != null) {
              controller.changeSortType(newValue);
            }
          },
        ),
      ),
    );
  }
}
