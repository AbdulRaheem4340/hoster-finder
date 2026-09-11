import 'package:get/get.dart';
import 'package:hostel_finder/presentation/controllers/owner_auth_controller.dart';

class OwnerAuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OwnerAuthController>(() => OwnerAuthController());
  }
}
