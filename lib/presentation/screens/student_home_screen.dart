import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import 'package:hostel_finder/core/constants/app_colors.dart';
import 'package:hostel_finder/core/routes/app_routes.dart';
import 'package:hostel_finder/presentation/controllers/student_map_controller.dart';
import 'package:hostel_finder/presentation/screens/hostel_preview_card.dart';
import 'package:hostel_finder/presentation/widget/filter_bottom_sheet.dart';
import 'package:hostel_finder/services/auth_service.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen>
    with TickerProviderStateMixin {
  late final StudentMapController controller;
  late final AuthService authService;

  @override
void initState() {
  super.initState();
  controller = Get.find<StudentMapController>();
  authService = Get.find<AuthService>();
  controller.attachVsync(this);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ///  MAP
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final userLoc = controller.studentLocation.value;
            final bool hasValidUserLocation =
                userLoc.latitude.isFinite && userLoc.longitude.isFinite;

            LatLng mapCenter;
            if (hasValidUserLocation) {
              mapCenter = userLoc;
            } else if (controller.filteredHostels.isNotEmpty) {
              final h = controller.filteredHostels.first;
              mapCenter = LatLng(h.latitude, h.longitude);
            } else {
              mapCenter = const LatLng(34.0151, 71.5249);
            }

            return FlutterMap(
              mapController: controller.mapController,
              options: MapOptions(
                initialCenter: mapCenter,
                initialZoom: 13.0,
                onTap: (_, _) => controller.clearSelection(),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'hostel_finder',
                ),

                if (hasValidUserLocation)
                  CircleLayer(
                    circles: [
                      CircleMarker(
                        point: userLoc,
                        radius: 50,
                        useRadiusInMeter: true,
                        color: Colors.blue.withValues(alpha: 0.15),
                        borderStrokeWidth: 1,
                        borderColor: Colors.blue.withValues(alpha: 0.4),
                      ),
                    ],
                  ),

                MarkerLayer(
                  markers: controller.filteredHostels
                      .where(
                        (h) =>
                            h.latitude.isFinite &&
                            h.longitude.isFinite &&
                            h.latitude != 0 &&
                            h.longitude != 0,
                      )
                      .map((hostel) {
                        return Marker(
                          point: LatLng(hostel.latitude, hostel.longitude),
                          width: 140,
                          height: 70,
                          child: GestureDetector(
                            onTap: () => controller.selectHostel(hostel),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    hostel.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 30,
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                      .toList(),
                ),

                if (hasValidUserLocation)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: userLoc,
                        width: 30,
                        height: 30,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            );
          }),

          Positioned(
            top: 50,
            left: 70,
            right: 70,
            child: const StudentSearchBar(),
          ),

          Positioned(
            top: 50,
            left: 15,
            child: GestureDetector(
              onTap: () async {
                await authService.logout();
                Get.offAllNamed(AppRoutes.welcome);
              },
              child: Container(
                height: 48,
                width: 48,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                child: const Icon(Icons.arrow_back, color: AppColors.primary),
              ),
            ),
          ),

          Positioned(
            top: 50,
            right: 15,
            child: GestureDetector(
              onTap: () => Get.bottomSheet(const FilterBottomSheet()),
              child: Container(
                height: 48,
                width: 48,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                ),
                child: const Icon(Icons.tune, color: Colors.white),
              ),
            ),
          ),

          Positioned(
            bottom: 140,
            right: 15,
            child: GestureDetector(
              onTap: () => controller.locateMe(),
              child: Container(
                height: 35,
                width: 35,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                ),
                child: const Icon(Icons.my_location, color: AppColors.primary),
              ),
            ),
          ),

          Obx(
            () => controller.selectedHostel.value != null
                ? Positioned(
                    bottom: 20,
                    left: 15,
                    right: 15,
                    child: HostelPreviewCard(
                      hostel: controller.selectedHostel.value!,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class StudentSearchBar extends StatelessWidget {
  const StudentSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentMapController>();

    return TextField(
      onChanged: (val) => controller.filterByCity(val),
      decoration: const InputDecoration(
        hintText: "Search area or hostel name...",
        border: InputBorder.none,
        prefixIcon: Icon(Icons.search, color: AppColors.primary),
      ),
    );
  }
}
