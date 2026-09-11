import 'package:get/get.dart';
import 'package:hostel_finder/presentation/controllers/splash_controller.dart';

class SplashControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SplashController>(SplashController());
  }
  
}