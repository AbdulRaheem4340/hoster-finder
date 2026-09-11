import 'package:get/get.dart';
import 'package:hostel_finder/core/middleware/role_guard.dart';
import 'package:hostel_finder/presentation/bindings/owner_auth_binding.dart';
import 'package:hostel_finder/presentation/bindings/owner_bindind.dart';
import 'package:hostel_finder/presentation/bindings/splash_controller_binding.dart';
import 'package:hostel_finder/presentation/bindings/student_auth_binding.dart';
import 'package:hostel_finder/presentation/bindings/detail_hostel_controller_binding.dart';
import 'package:hostel_finder/presentation/bindings/student_map_controller_binding.dart';
import 'package:hostel_finder/presentation/screens/admin_dashboard_screen.dart';
import 'package:hostel_finder/presentation/screens/hostel_detail_screen.dart';
import 'package:hostel_finder/presentation/screens/map_picker_screen.dart';
import 'package:hostel_finder/presentation/screens/owner_dash_board_screen.dart';
import 'package:hostel_finder/presentation/screens/splash_screen.dart';
import 'package:hostel_finder/presentation/screens/welcome_screen.dart';
import 'package:hostel_finder/presentation/screens/student_login_screen.dart';
import 'package:hostel_finder/presentation/screens/student_register_screen.dart';
import 'package:hostel_finder/presentation/screens/owner_login_screen.dart';
import 'package:hostel_finder/presentation/screens/owner_register_screen.dart';
import 'package:hostel_finder/presentation/screens/add_hostel_screen.dart';
import 'package:hostel_finder/presentation/screens/student_home_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String studentLogin = '/student-login';
  static const String studentRegister = '/student-register';
  static const String ownerLogin = '/owner-login';
  static const String ownerRegister = '/owner-register';
  static const String ownerDashboard = '/owner-dashboard';
  static const String addHostel = '/add-hostel';
  static const String studentHome = '/student-home';
  static const String mapPicker = '/mapPicker';
  static const String hostelDetail = '/hostel-details';
  static const String adminDashboard = '/admin-dashboard';

  static List<GetPage> pages = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
      binding: SplashControllerBinding(),
    ),
    GetPage(name: welcome, page: () => const WelcomeScreen()),

    GetPage(
      name: studentLogin,
      page: () => const StudentLoginScreen(),
      binding: StudentAuthBinding(),
    ),
    GetPage(
      name: studentRegister,
      page: () => const StudentRegisterScreen(),
      binding: StudentAuthBinding(),
    ),

    GetPage(
      name: ownerLogin,
      page: () => const OwnerLoginScreen(),
      binding: OwnerAuthBinding(),
    ),
    GetPage(
      name: ownerRegister,
      page: () => const OwnerRegisterScreen(),
      binding: OwnerAuthBinding(),
    ),

    GetPage(
      name: addHostel,
      page: () => const AddHostelScreen(),
      binding: OwnerBindind(),
    ),
    GetPage(
      name: mapPicker,
      page: () => const MapPickerScreen(),
      binding: OwnerBindind(),
    ),
    GetPage(
      name: hostelDetail,
      page: () => const HostelDetailsScreen(),
      binding: DetailHostelControllerBinding(),
    ),

    GetPage(
      name: ownerDashboard,
      page: () => const OwnerDashboardScreen(),
      binding: OwnerBindind(),
      middlewares: [RoleGuard('owner')],
    ),
    GetPage(
      name: studentHome,
      page: () => const StudentHomeScreen(),
      binding: StudentMapControllerBinding(),
      middlewares: [RoleGuard('student')],
    ),
    GetPage(
      name: adminDashboard,
      page: () => const AdminDashboardScreen(),
      middlewares: [RoleGuard('admin')],
    ),
  ];
}
