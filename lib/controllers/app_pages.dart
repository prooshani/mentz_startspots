import 'package:get/get.dart';
import 'package:mentz_startspots/controllers/app_routes.dart';
import 'package:mentz_startspots/controllers/home_bindings.dart';
import 'package:mentz_startspots/home.dart';
import 'package:mentz_startspots/splash.dart';

class AppPages {
  static var list = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      //  binding: DashboardBinding(),
    ),
  ];
}
