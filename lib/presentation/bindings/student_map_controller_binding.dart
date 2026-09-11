import 'package:get/get.dart';
import 'package:hostel_finder/presentation/controllers/student_map_controller.dart';

class StudentMapControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentMapController>(() => StudentMapController(),);
  }
  
}