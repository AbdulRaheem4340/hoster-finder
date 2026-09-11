
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_finder/presentation/controllers/owner_controller.dart';
import 'package:hostel_finder/presentation/screens/map_picker_screen.dart';

///  GPS + Map picker buttons
class LocationActionButtons extends StatelessWidget {
  const LocationActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OwnerController>();
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => controller.getCurrentLocation(),
            icon: const Icon(Icons.my_location, size: 18),
            label: const Text("Get GPS"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => Get.to(() => const MapPickerScreen()),
            icon: const Icon(Icons.map, size: 18),
            label: const Text("Map Picker"),
          ),
        ),
      ],
    );
  }
}