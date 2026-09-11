import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hostel_finder/presentation/controllers/owner_controller.dart';
import 'package:hostel_finder/presentation/widget/location_action_button.dart';
import 'package:hostel_finder/presentation/widget/location_display_card.dart';
import 'package:hostel_finder/presentation/widget/facility_selector.dart';
import 'package:hostel_finder/presentation/widget/multi_photo_picker.dart';
import 'package:hostel_finder/presentation/widget/save_hostel_button.dart';

class AddHostelScreen extends StatelessWidget {
  const AddHostelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OwnerController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.editingHostel == null ? "Add New Hostel" : "Edit Hostel",
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(title: "Hostel Photo"),
            const SizedBox(height: 10),
            const MultiPhotoPicker(),

            const SizedBox(height: 25),
            const SectionTitle(title: "Basic Information"),
            const SizedBox(height: 15),

            TextField(
              controller: controller.nameController,
              decoration: const InputDecoration(labelText: "Hostel Name"),
            ),
            const SizedBox(height: 10),
            // address
            TextField(
              controller: controller.addressController,
              keyboardType: TextInputType.streetAddress,
              decoration: const InputDecoration(
                labelText: "Address (City/Area)",
              ),
            ),
            const SizedBox(height: 10),

            // rent 
            TextField(
              controller: controller.rentController,
              decoration: const InputDecoration(
                labelText: "Monthly Rent (PKR)",
                prefixIcon: Icon(Icons.attach_money, size: 20),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
         

            const SizedBox(height: 10),

            //   Rooms (Total + Available)
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.roomsController,
                    decoration: const InputDecoration(
                      labelText: "Total Rooms",
                      prefixIcon: Icon(Icons.meeting_room, size: 20),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: controller.availableRoomsController,
                    decoration: const InputDecoration(
                      labelText: "Available Rooms",
                      prefixIcon: Icon(Icons.event_available, size: 20),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            //  Contact
            TextField(
              controller: controller.contactController,
              decoration: const InputDecoration(labelText: "Contact No"),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
            ),

            const SizedBox(height: 25),
            const SectionTitle(title: "Facilities"),
            const SizedBox(height: 10),
            const FacilitySelector(),

            const SizedBox(height: 25),
            const SectionTitle(title: "Verify Location"),
            const SizedBox(height: 10),
            const LocationDisplayCard(),
            const SizedBox(height: 15),
            const LocationActionButtons(),

            const SizedBox(height: 40),
            const SaveHostelButton(),
          ],
        ),
      ),
    );
  }
}

///  Reusable section heading
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}
