import 'package:booktickets/utils/app_layout.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double? borderRadius;
  final List<BoxShadow>? boxShadow;

  const CustomCard({
    Key? key,
    required this.child,
    this.margin,
    this.padding,
    this.color,
    this.borderRadius,
    this.boxShadow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.all(AppLayout.getWidth(15)),
      padding: padding ?? EdgeInsets.all(AppLayout.getWidth(15)),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius ?? AppLayout.getHeight(10)),
        boxShadow: boxShadow ?? [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}