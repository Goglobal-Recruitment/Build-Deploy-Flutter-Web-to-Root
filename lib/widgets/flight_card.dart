import 'package:booktickets/models/flight.dart';
import 'package:booktickets/utils/app_layout.dart';
import 'package:booktickets/utils/app_styles.dart';
import 'package:booktickets/widgets/badge_widget.dart';
import 'package:booktickets/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FlightCard extends StatelessWidget {
  final Flight flight;
  final VoidCallback onTap;

  const FlightCard({
    Key? key,
    required this.flight,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge
            BadgeWidget(
              text: flight.badgeType,
              color: _getBadgeColor(flight.badgeType),
            ),
            Gap(AppLayout.getHeight(10)),
            
            // Flight info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  flight.departureTime.formatTime(),
                  style: Styles.headLineStyle1,
                ),
                Column(
                  children: [
                    Text(
                      '${flight.duration ~/ 60}h ${flight.duration % 60}m',
                      style: Styles.headLineStyle4,
                    ),
                    const Icon(
                      Icons.flight_takeoff,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ],
                ),
                Text(
                  flight.arrivalTime.formatTime(),
                  style: Styles.headLineStyle1,
                ),
              ],
            ),
            Gap(AppLayout.getHeight(5)),
            
            // Route
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  flight.originCode,
                  style: Styles.headLineStyle3,
                ),
                const Expanded(
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                ),
                Text(
                  flight.destinationCode,
                  style: Styles.headLineStyle3,
                ),
              ],
            ),
            Gap(AppLayout.getHeight(10)),
            
            // Airline and flight number
            Text(
              '${flight.airlineName} • ${flight.flightNumber}',
              style: Styles.headLineStyle4,
            ),
            Gap(AppLayout.getHeight(10)),
            
            // Best price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'From \$${flight.bestPrice.toStringAsFixed(2)}',
                  style: Styles.headLineStyle1.copyWith(
                    color: Styles.primaryColor,
                    fontSize: 20,
                  ),
                ),
                const Icon(Icons.arrow_forward_ios),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getBadgeColor(String badgeType) {
    switch (badgeType) {
      case 'Direct':
        return Styles.successColor;
      case 'Fastest':
        return Styles.warningColor;
      default:
        return Styles.primaryColor;
    }
  }
}

extension on DateTime {
  String formatTime() {
    return '${this.hour.toString().padLeft(2, '0')}:${this.minute.toString().padLeft(2, '0')}';
  }
}