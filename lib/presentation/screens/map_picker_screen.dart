import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hostel_finder/core/utils/app_utils.dart';
import 'package:hostel_finder/presentation/controllers/owner_controller.dart';
import 'package:latlong2/latlong.dart';

class MapPickerScreen extends StatelessWidget {
  const MapPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OwnerController>();
    final MapController mapController = MapController();

    return Scaffold(
      appBar: AppBar(title: const Text("Select Location")),
      body: Stack(
        children: [
          // Basic Map Layer
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter:
                  controller.selectedLocation.value ??
                  const LatLng(30.3753, 69.3451),
              initialZoom: 6.0,
              onTap: (tapPosition, point) => controller.setLocation(point),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'hostel_finder',
              ),
              Obx(
                () => MarkerLayer(
                  markers: [
                    if (controller.selectedLocation.value != null)
                      Marker(
                        point: controller.selectedLocation.value!,
                        width: 50,
                        height: 50,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 45,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          // Floating Search Bar
          Positioned(
            top: 20,
            left: 15,
            right: 15,
            child: MapSearchBar(mapController: mapController),
          ),

          // Confirm Button
          Positioned(
            bottom: 30,
            left: 60,
            right: 60,
            child: ElevatedButton(
              onPressed: () {
                if (controller.selectedLocation.value != null) {
                  Get.back();
                } else {
                  AppUtils.showError("Please pick a location");
                }
              },
              child: const Text("Confirm Location"),
            ),
          ),
        ],
      ),
    );
  }
}

class MapSearchBar extends StatelessWidget {
  final MapController mapController;
  const MapSearchBar({super.key, required this.mapController});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OwnerController>();
    final searchInput = TextEditingController();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10),
        ],
      ),
      child: TextField(
        controller: searchInput,
        onSubmitted: (val) => controller.searchLocation(val, mapController),
        decoration: InputDecoration(
          hintText: "Search Area (e.g. Karachi)",
          prefixIcon: const Icon(Icons.search),
          suffixIcon: Obx(
            () => controller.isSearching.value
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => controller.searchLocation(
                      searchInput.text,
                      mapController,
                    ),
                  ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}
