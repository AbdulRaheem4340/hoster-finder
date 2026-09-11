import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_finder/presentation/controllers/owner_controller.dart';

///  Location display card
class LocationDisplayCard extends StatelessWidget {
  const LocationDisplayCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OwnerController>();
    return Obx(() {
      final loc = controller.selectedLocation.value;
      final hasLoc = loc != null;
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: hasLoc
              ? Colors.green.withValues(alpha: 0.05)
              : Colors.red.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: hasLoc
                ? Colors.green.withValues(alpha: 0.2)
                : Colors.red.withValues(alpha: 0.2),
          ),
        ),
        child: hasLoc
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Captured ✅",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("Lat: ${loc.latitude.toStringAsFixed(6)}"),
                  Text("Lng: ${loc.longitude.toStringAsFixed(6)}"),
                ],
              )
            : const Text(
                "⚠️ Location required",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
      );
    });
  }
}
