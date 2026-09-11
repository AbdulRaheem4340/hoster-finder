import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_finder/core/constants/app_colors.dart';
import 'package:hostel_finder/presentation/controllers/hostel_detail_conroller.dart';
import 'package:hostel_finder/presentation/widget/hostel_image_carousel.dart';

class HostelDetailsScreen extends StatelessWidget {
  const HostelDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HostelDetailController>();
    final hostel = controller.hostel;

    return Scaffold(
      appBar: AppBar(title: Text(hostel.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //   Image Carousel
            HostelImageCarousel(imageUrls: hostel.allImages),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //  Name + Rent
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          hostel.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        "${hostel.rent.toInt()} PKR/m",
                        style: const TextStyle(
                          fontSize: 20,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  //  Address
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 18,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          hostel.address,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 40),

                  //  Hostel Information
                  const Text(
                    "Hostel Information",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  //  Availability summary banner
                  AvailabilityBanner(
                    totalRooms: hostel.totalRooms,
                    availableRooms: hostel.availableRooms,
                  ),

                  const SizedBox(height: 15),

                  //  Info tiles row
                  Row(
                    children: [
                      Expanded(
                        child: InfoTile(
                          icon: Icons.meeting_room,
                          label: "Total Rooms",
                          value: "${hostel.totalRooms}",
                        ),
                      ),
                      Expanded(
                        child: InfoTile(
                          icon: Icons.event_available,
                          label: "Available",
                          value: "${hostel.availableRooms}",
                          valueColor: hostel.isFull ? Colors.red : Colors.green,
                        ),
                      ),
                      Expanded(
                        child: InfoTile(
                          icon: Icons.person,
                          label: "Occupied",
                          value: "${hostel.occupiedRooms}",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  //  Facilities
                  const Text(
                    "Facilities Provided",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: hostel.facilities
                        .map(
                          (f) => Chip(
                            label: Text(
                              f,
                              style: const TextStyle(fontSize: 12),
                            ),
                            backgroundColor: AppColors.primary.withValues(
                              alpha: 0.1,
                            ),
                            side: BorderSide.none,
                          ),
                        )
                        .toList(),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),

      // 6.  Contact +  Directions Buttons
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              //  Call
              ContactIconButton(
                icon: Icons.call,
                color: Colors.blueGrey,
                tooltip: "Call Now",
                onTap: () => controller.makeCall(),
              ),
              const SizedBox(width: 10),

              // 💬 WhatsApp
              ContactIconButton(
                icon: Icons.chat,
                color: const Color(0xFF25D366),
                tooltip: "Chat on WhatsApp",
                onTap: () => controller.openWhatsApp(),
              ),
              const SizedBox(width: 12),

              //  Get Directions
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => controller.openDirections(),
                  icon: const Icon(Icons.directions, size: 20),
                  label: const Text(
                    "Get Directions",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///  Info tile
class InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const InfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: valueColor ?? Colors.black87,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}

///  Availability banner
class AvailabilityBanner extends StatelessWidget {
  final int totalRooms;
  final int availableRooms;

  const AvailabilityBanner({
    super.key,
    required this.totalRooms,
    required this.availableRooms,
  });

  @override
  Widget build(BuildContext context) {
    final isFull = availableRooms <= 0;
    final color = isFull ? Colors.red : Colors.green;
    final occupancyRate = totalRooms == 0
        ? 0.0
        : (totalRooms - availableRooms) / totalRooms;

    final statusText = isFull
        ? "No rooms available right now"
        : "$availableRooms of $totalRooms rooms available";

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isFull ? Icons.do_not_disturb : Icons.check_circle,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: occupancyRate,
              minHeight: 6,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "${(occupancyRate * 100).toInt()}% occupied",
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class ContactIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  const ContactIconButton({
    super.key,
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: color.withValues(alpha: 0.12),
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            child: Icon(icon, color: color, size: 24),
          ),
        ),
      ),
    );
  }
}
