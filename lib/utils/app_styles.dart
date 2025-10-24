import 'package:flutter/material.dart';

// Updated color palette for SkyQuest branding
Color primary = const Color(0xFF1D6ED6); // Vibrant Blue
Color secondary = const Color(0xFF0E2D5D); // Deep Navy

class Styles{
  static Color primaryColor = primary;
  static Color secondaryColor = secondary;
  static Color textColor = const Color(0xFF3B3B3B); // Charcoal
  static Color textLightColor = const Color(0xFF8F8F8F); // Medium Gray
  static Color bgColor = const Color(0xFFF4F6FD); // Light Gray
  static Color accentColor = const Color(0xFFACD4FC); // Light Sky Blue
  static Color successColor = const Color(0xFF4CAF50); // Green
  static Color warningColor = const Color(0xFFFF9800); // Orange
  static Color errorColor = const Color(0xFFF44336); // Red
  
  static TextStyle textStyle = TextStyle(
    fontSize: 16, 
    color: textColor,
    fontWeight: FontWeight.w500
  );
  
  static TextStyle headLineStyle1 = TextStyle(
    fontSize: 26, 
    color: secondaryColor,
    fontWeight: FontWeight.bold
  );
  
  static TextStyle headLineStyle2 = TextStyle(
    fontSize: 21, 
    color: secondaryColor,
    fontWeight: FontWeight.bold
  );
  
  static TextStyle headLineStyle3 = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w500
  );
  
  static TextStyle headLineStyle4 = TextStyle(
    fontSize: 14, 
    color: textLightColor,
    fontWeight: FontWeight.w500
  );
}