import 'package:get/get.dart';
import 'package:hostel_finder/presentation/widget/navigation_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hostel_finder/data/models/hostel_model.dart';
import 'package:hostel_finder/core/utils/app_utils.dart';


class HostelDetailController extends GetxController {
  
  final HostelModel hostel = Get.arguments;

  //  Launch Phone Dialer
  Future<void> makeCall() async {
    final Uri url = Uri.parse('tel:${hostel.contact}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      AppUtils.showError("Could not launch phone dialer");
    }
  }

  //  Launch WhatsApp
  Future<void> openWhatsApp() async {
    
    String phone = hostel.contact.replaceAll(RegExp(r'[^0-9]'), '');

    // Ensure it has country code (Adding 92 for Pakistan if missing)
    if (phone.startsWith('0')) {
      phone = '92${phone.substring(1)}';
    }

    final String message =
        "Hello, I am interested in your hostel '${hostel.name}' found on Hostel Finder app.";
    final Uri url = Uri.parse(
      "https://wa.me/$phone?text=${Uri.encodeComponent(message)}",
    );

    if (await launchUrl(url, mode: LaunchMode.externalApplication)) {
      // Success
    } else {
      AppUtils.showError("WhatsApp is not installed or number is invalid");
    }
  }

  
  Future<void> openDirections() async {
    final success = await NavigationHelper.openDirections(
      latitude: hostel.latitude,
      longitude: hostel.longitude,
      label: hostel.name,
    );

    // Show error only if launching failed
    if (!success) {
      AppUtils.showError("Could not open maps app");
    }
  }
}