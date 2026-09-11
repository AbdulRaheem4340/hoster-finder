import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_finder/core/constants/app_colors.dart';
import 'package:hostel_finder/core/routes/app_routes.dart';
import 'package:hostel_finder/data/models/hostel_model.dart';
import 'package:hostel_finder/presentation/controllers/student_map_controller.dart';

class HostelPreviewCard extends StatelessWidget {
  final HostelModel hostel;
  const HostelPreviewCard({super.key, required this.hostel});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(15),
        height: 150,
        child: Row(
          children: [
            //  Use cover image (first photo from list)
            HostelThumbnail(
              url: hostel.coverImage,
              photoCount: hostel.allImages.length,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hostel.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 12,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          hostel.address,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  //  Distance +  Availability
                  Row(
                    children: [
                      HostelDistanceLabel(
                        latitude: hostel.latitude,
                        longitude: hostel.longitude,
                      ),
                      const SizedBox(width: 6),
                      AvailabilityBadge(hostel: hostel),
                    ],
                  ),

                  const Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${hostel.rent.toInt()} PKR",
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Get.toNamed(
                            AppRoutes.hostelDetail,
                            arguments: hostel,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          minimumSize: const Size(70, 35),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          "Details",
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///  Hostel image thumbnail with photo count badge
class HostelThumbnail extends StatelessWidget {
  final String? url;
  final int? photoCount;

  const HostelThumbnail({super.key, required this.url, this.photoCount});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(15),
          ),
          child: url != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    url!,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (_, _, _) => const Icon(
                      Icons.home_work,
                      color: Colors.grey,
                      size: 35,
                    ),
                  ),
                )
              : const Icon(Icons.home_work, color: Colors.grey, size: 35),
        ),

        //  Photo count badge
        if (photoCount != null && photoCount! > 1)
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.photo_library, color: Colors.white, size: 9),
                  const SizedBox(width: 2),
                  Text(
                    "$photoCount",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

///  Distance label
class HostelDistanceLabel extends StatelessWidget {
  final double latitude;
  final double longitude;

  const HostelDistanceLabel({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentMapController>();
    return Obx(() {
      controller.studentLocation.value;
      final distance = controller.distanceToHostel(latitude, longitude);

      if (distance == null) return const SizedBox.shrink();

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.directions_walk, size: 12, color: AppColors.primary),
          const SizedBox(width: 2),
          Text(
            distance,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    });
  }
}

///  Availability badge
class AvailabilityBadge extends StatelessWidget {
  final HostelModel hostel;
  const AvailabilityBadge({super.key, required this.hostel});

  @override
  Widget build(BuildContext context) {
    final isFull = hostel.isFull;
    final color = isFull ? Colors.red : Colors.green;
    final text = isFull ? "Full" : "${hostel.availableRooms} available";
    final icon = isFull ? Icons.do_not_disturb : Icons.check_circle;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 3),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
