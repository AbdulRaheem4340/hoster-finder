import 'package:get/get.dart';
import 'package:hostel_finder/presentation/controllers/hostel_detail_conroller.dart';

class DetailHostelControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HostelDetailController>(() => HostelDetailController(),);
  }
  
}