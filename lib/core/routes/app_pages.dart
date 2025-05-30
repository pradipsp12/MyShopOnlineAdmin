import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../screens/Auth/login_screen.dart';
import '../../screens/main/main_screen.dart';
import '../../screens/Auth/provider/auth_service_provider.dart';

class AppPages {
  static const HOME = '/';
  static const LOGIN = '/login';

  static final routes = [
    GetPage(
      name: HOME,
      page: () => MainScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: LOGIN,
      page: () => LoginScreen(),
    ),
  ];
}

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authService = Get.find<AuthService>();
    return authService.isAuthenticated ? null : const RouteSettings(name: AppPages.LOGIN);
  }
}