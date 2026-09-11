import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hostel_finder/core/routes/app_routes.dart';
import 'package:hostel_finder/services/firestore_service.dart';

///  Splash Controller — decides where to send the user when app opens.
class SplashController extends GetxController {
  final FirestoreService _firestoreService = Get.find<FirestoreService>();


  @override
  void onReady() {
    super.onReady();
    _checkUserStatus();
  }

  void _checkUserStatus() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Get.offAllNamed(AppRoutes.welcome);
      return;
    }


    try {
      final userData = await _firestoreService.getUserData(user.uid);

      if (userData == null) {
        Get.offAllNamed(AppRoutes.welcome);
        return;
      }


      switch (userData.role) {
        case 'admin':
          Get.offAllNamed(AppRoutes.adminDashboard);
          break;
        case 'owner':
          Get.offAllNamed(AppRoutes.ownerDashboard);
          break;
        case 'student':
        default:
          Get.offAllNamed(AppRoutes.studentHome);
      }
    } catch (e) {
      Get.offAllNamed(AppRoutes.welcome);
    }
  }
}