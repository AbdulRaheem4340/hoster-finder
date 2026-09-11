import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hostel_finder/core/routes/app_routes.dart';
import 'package:hostel_finder/core/constants/app_theme.dart';
import 'package:hostel_finder/presentation/bindings/inital_binding.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const HostelFinderApp());
}

class HostelFinderApp extends StatelessWidget {
  const HostelFinderApp({super.key});

  @override 
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Hostel Finder',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.pages,
    );
  }
}
