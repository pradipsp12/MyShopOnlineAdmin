import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'responsive.dart'; // Import the Responsive widget

class SnackBarHelper {
  static void showErrorSnackBar(String message, {String title = "Error"}) {
    final context = Get.context!;
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive margins
    final margin = Responsive.isMobile(context)
        ? EdgeInsets.symmetric(horizontal: 16, vertical: 8) // Smaller margin for mobile
        : Responsive.isTablet(context)
            ? EdgeInsets.symmetric(horizontal: screenWidth * 0.2, vertical: 12) // Medium margin for tablet
            : EdgeInsets.symmetric(horizontal: screenWidth * 0.3, vertical: 16); // Larger margin for desktop

    // Responsive font and icon sizes
    final titleTextStyle = TextStyle(
      fontSize: Responsive.isMobile(context) ? 14 : 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
    final messageTextStyle = TextStyle(
      fontSize: Responsive.isMobile(context) ? 12 : 14,
      color: Colors.white,
    );
    final iconSize = Responsive.isMobile(context) ? 20.0 : 24.0;

    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      borderRadius: Responsive.isMobile(context) ? 12 : 20, // Smaller radius on mobile
      margin: margin,
      padding: Responsive.isMobile(context)
          ? EdgeInsets.symmetric(horizontal: 12, vertical: 8)
          : EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      duration: Duration(seconds: 3),
      icon: Icon(Icons.error, color: Colors.white, size: iconSize),
      titleText: Text(
        title,
        style: titleTextStyle,
      ),
      messageText: Text(
        message,
        style: messageTextStyle,
      ),
      snackPosition: SnackPosition.BOTTOM, // Consistent position
    );
  }

  static void showSuccessSnackBar(String message, {String title = "Success"}) {
    final context = Get.context!;
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive margins
    final margin = Responsive.isMobile(context)
        ? EdgeInsets.symmetric(horizontal: 16, vertical: 8)
        : Responsive.isTablet(context)
            ? EdgeInsets.symmetric(horizontal: screenWidth * 0.2, vertical: 12)
            : EdgeInsets.symmetric(horizontal: screenWidth * 0.3, vertical: 16);

    // Responsive font and icon sizes
    final titleTextStyle = TextStyle(
      fontSize: Responsive.isMobile(context) ? 14 : 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
    final messageTextStyle = TextStyle(
      fontSize: Responsive.isMobile(context) ? 12 : 14,
      color: Colors.white,
    );
    final iconSize = Responsive.isMobile(context) ? 20.0 : 24.0;

    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      borderRadius: Responsive.isMobile(context) ? 12 : 20,
      margin: margin,
      padding: Responsive.isMobile(context)
          ? EdgeInsets.symmetric(horizontal: 12, vertical: 8)
          : EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      duration: Duration(seconds: 3),
      icon: Icon(Icons.check_circle, color: Colors.white, size: iconSize),
      titleText: Text(
        title,
        style: titleTextStyle,
      ),
      messageText: Text(
        message,
        style: messageTextStyle,
      ),
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}