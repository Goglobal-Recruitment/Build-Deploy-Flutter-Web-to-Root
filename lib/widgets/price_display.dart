import 'package:booktickets/utils/app_layout.dart';
import 'package:booktickets/utils/app_styles.dart';
import 'package:flutter/material.dart';

class PriceDisplay extends StatelessWidget {
  final double price;
  final String? label;
  final bool isLarge;
  final Color? color;

  const PriceDisplay({
    Key? key,
    required this.price,
    this.label,
    this.isLarge = false,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label!,
            style: Styles.headLineStyle4,
          ),
        Text(
          'R${price.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isLarge ? 24 : 18,
            fontWeight: FontWeight.bold,
            color: color ?? Styles.primaryColor,
          ),
        ),
      ],
    );
  }
}