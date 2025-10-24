import 'package:booktickets/utils/app_layout.dart';
import 'package:booktickets/utils/app_styles.dart';
import 'package:flutter/material.dart';

class BadgeWidget extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? textColor;
  final double? fontSize;

  const BadgeWidget({
    Key? key,
    required this.text,
    this.color,
    this.textColor,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppLayout.getWidth(10),
        vertical: AppLayout.getHeight(5),
      ),
      decoration: BoxDecoration(
        color: color ?? Styles.primaryColor,
        borderRadius: BorderRadius.circular(AppLayout.getHeight(5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: fontSize ?? 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}