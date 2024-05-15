import 'package:flutter/material.dart';
import 'dart:ui';

class AppStyles {
  static const Color primaryColor = Color(0xFF607D8B);
  static const Color secondaryColor = Color(0xFF455A64);
  static const Color backgroundColor = Color(0xFF263238);
  static const Color gradientStartColor = Color(0xFF37474F);
  static const Color gradientEndColor = Color(0xFF455A64);

  static BoxDecoration containerDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [gradientStartColor, gradientEndColor],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          spreadRadius: 5,
          blurRadius: 10,
          offset: Offset(0, 3),
        ),
      ],
    );
  }

  static BoxDecoration bottomRoundedDecoration() {
    return BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/wallet-back.jpg"),
        fit: BoxFit.cover,
      ),
      gradient: LinearGradient(
        colors: [gradientStartColor, gradientEndColor],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          spreadRadius: 5,
          blurRadius: 10,
          offset: Offset(0, 3),
        ),
      ],
    );
  }

  Widget blurredBackground() {
    return Container(
      decoration: bottomRoundedDecoration(), // Apply the custom decoration
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Adjust sigmaX and sigmaY for blur level
        child: Container(
          color: Colors.black.withOpacity(0), // Keep it transparent
        ),
      ),
    );
  }



  static BoxDecoration buttonDecoration() {
    return BoxDecoration(
      color: primaryColor,
      borderRadius: BorderRadius.circular(15),
    );
  }

  static TextStyle buttonTextStyle() {
    return TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle whiteTextStyle(double fontSize, [FontWeight fontWeight = FontWeight.normal]) {
    return TextStyle(
      color: Colors.white,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }

  static TextStyle greyTextStyle(double fontSize, [FontStyle fontStyle = FontStyle.normal]) {
    return TextStyle(
      color: Colors.grey,
      fontSize: fontSize,
      fontStyle: fontStyle,
    );
  }

  static BoxDecoration assetContainerDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [primaryColor, secondaryColor],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(10),
    );
  }
}