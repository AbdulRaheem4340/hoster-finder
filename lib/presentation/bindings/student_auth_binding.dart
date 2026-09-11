import 'package:get/get.dart';
import 'package:hostel_finder/presentation/controllers/student_auth_controller.dart';

class StudentAuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentAuthController>(() => StudentAuthController());
  }
}
