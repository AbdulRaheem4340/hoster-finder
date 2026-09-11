import 'package:get/instance_manager.dart';
import 'package:hostel_finder/presentation/controllers/owner_controller.dart';

class OwnerBindind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OwnerController>(() => OwnerController(),);
  }
  
}