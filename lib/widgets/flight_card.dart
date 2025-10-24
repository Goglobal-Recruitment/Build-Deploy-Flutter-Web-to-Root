import 'package:booktickets/models/flight.dart';
import 'package:booktickets/utils/app_layout.dart';
import 'package:booktickets/utils/app_styles.dart';
import 'package:booktickets/widgets/badge_widget.dart';
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(AppLayout.getHeight(10)),
        padding: EdgeInsets.all(AppLayout.getHeight(15)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppLayout.getHeight(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge if applicable
            if (flight.badgeType != null)
              BadgeWidget(
                text: flight.badgeType!,
                color: flight.badgeType == 'DIRECT'
                    ? Styles.successColor
                    : flight.badgeType == 'FASTEST'
                        ? Styles.warningColor
                        : Styles.primaryColor,
              ),
            Gap(AppLayout.getHeight(10)),
            
            // Flight details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Departure time and airport
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      flight.departureTime.formatTime(),
                      style: Styles.headLineStyle1,
                    ),
                    Text(
                      flight.originCode,
                      style: Styles.headLineStyle3,
                    ),
                  ],
                ),
                
                // Duration and flight icon
                Column(
                  children: [
                    Text(
                      '${flight.duration ~/ 60}h ${flight.duration % 60}m',
                      style: Styles.headLineStyle4,
                    ),
                    Gap(AppLayout.getHeight(5)),
                    const Icon(
                      Icons.flight_takeoff,
                      color: Colors.blue,
                      size: 24,
                    ),
                    Gap(AppLayout.getHeight(5)),
                    Text(
                      flight.stops == 0 
                        ? 'Direct' 
                        : '${flight.stops} stop${flight.stops > 1 ? 's' : ''}',
                      style: Styles.headLineStyle4,
                    ),
                  ],
                ),
                
                // Arrival time and airport
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      flight.arrivalTime.formatTime(),
                      style: Styles.headLineStyle1,
                    ),
                    Text(
                      flight.destinationCode,
                      style: Styles.headLineStyle3,
                    ),
                  ],
                ),
              ],
            ),
            
            Gap(AppLayout.getHeight(15)),
            
            // Airline and flight number
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${flight.airlineName} • ${flight.flightNumber}',
                  style: Styles.headLineStyle3,
                ),
                // Best price
                Text(
                  'From R${flight.bestPrice.toStringAsFixed(2)}',
                  style: Styles.headLineStyle1.copyWith(
                    color: Styles.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}