import 'package:get/get.dart';
import 'package:hostel_finder/services/auth_service.dart';
import 'package:hostel_finder/services/firestore_service.dart';
  
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthService(), permanent: true);
    Get.put(FirestoreService(), permanent: true);
  }
}