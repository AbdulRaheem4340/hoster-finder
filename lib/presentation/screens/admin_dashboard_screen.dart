import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_finder/services/auth_service.dart';
import 'package:hostel_finder/services/firestore_service.dart';
import 'package:hostel_finder/data/models/hostel_model.dart';
import 'package:hostel_finder/core/routes/app_routes.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = Get.find<FirestoreService>();
    final fireAuth = Get.find<AuthService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Panel"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              fireAuth.logout();
              Get.offAllNamed(AppRoutes.welcome);
            },
          ),
        ],
      ),
      body: StreamBuilder<List<HostelModel>>(
        stream: firestoreService.getAllHostelsForAdmin(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No Hostels Found"));
          }

          final hostels = snapshot.data!;
          final approved = hostels.where((h) => h.isActive).length;
          final pending = hostels.where((h) => !h.isActive).length;

          return Column(
            children: [
              //  Stats Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _statCard("Total", hostels.length, Colors.blue),
                    _statCard("Approved", approved, Colors.green),
                    _statCard("Pending", pending, Colors.orange),
                  ],
                ),
              ),

              const Divider(),

              //  Hostels List
              Expanded(
                child: ListView.builder(
                  itemCount: hostels.length,
                  itemBuilder: (context, index) {
                    final hostel = hostels[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        title: Text(
                          hostel.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Owner: ${hostel.ownerName ?? "Unknown"}"),
                              Text("Contact: ${hostel.contact}"),
                              Text(
                                "Status: ${hostel.isActive ? "Approved" : "Pending"}",
                                style: TextStyle(
                                  color: hostel.isActive
                                      ? Colors.green
                                      : Colors.orange,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: Wrap(
                          spacing: 8,
                          children: [
                            IconButton(
                              icon: Icon(
                                hostel.isActive
                                    ? Icons.check_circle
                                    : Icons.hourglass_empty,
                                color: hostel.isActive
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                              tooltip: hostel.isActive
                                  ? "Unapprove Hostel"
                                  : "Approve Hostel",
                              onPressed: () {
                                firestoreService.updateHostelApproval(
                                  hostel.id,
                                  !hostel.isActive,
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              tooltip: "Delete Hostel",
                              onPressed: () {
                                firestoreService.deleteHostel(hostel.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _statCard(String label, int value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            "$value",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
