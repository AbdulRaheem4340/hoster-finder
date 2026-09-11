import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_finder/core/constants/app_colors.dart';
import 'package:hostel_finder/core/routes/app_routes.dart';
import 'package:hostel_finder/presentation/controllers/owner_controller.dart';
import 'package:hostel_finder/data/models/hostel_model.dart';

class OwnerDashboardScreen extends StatelessWidget {
  const OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OwnerController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Hostels"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Get.offAllNamed(AppRoutes.welcome),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.myHostels.isEmpty) {
          return const Center(child: Text("No hostels added yet."));
        }
        return ListView.builder(
          itemCount: controller.myHostels.length,
          itemBuilder: (context, index) {
            return HostelListItem(hostel: controller.myHostels[index]);
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.clearFormForNewHostel();
          Get.toNamed(AppRoutes.addHostel);
        },
        backgroundColor: AppColors.secondary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class HostelListItem extends StatelessWidget {
  final HostelModel hostel;
  const HostelListItem({super.key, required this.hostel});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OwnerController>();
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          hostel.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("${hostel.rent} PKR/month"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.secondary),
              onPressed: () => controller.prepareEdit(hostel),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () =>
                  _showDeleteDialog(context, controller, hostel.id),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    OwnerController controller,
    String id,
  ) {
    Get.defaultDialog(
      title: "Delete Hostel",
      middleText: "Are you sure you want to remove this listing?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        controller.deleteHostel(id);
        Get.back();
      },
    );
  }
}
