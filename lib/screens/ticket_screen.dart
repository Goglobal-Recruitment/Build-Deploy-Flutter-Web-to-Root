import 'package:booktickets/screens/ticket_view.dart';
import 'package:booktickets/utils/app_info_list.dart';
import 'package:booktickets/utils/app_layout.dart';
import 'package:booktickets/utils/app_styles.dart';
import 'package:booktickets/widgets/ticket_tabs.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TicketScreen extends StatelessWidget {

  const TicketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.bgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.airline_seat_recline_normal,
              size: 80,
              color: Styles.primaryColor,
            ),
            Gap(AppLayout.getHeight(20)),
            Text(
              'Your Tickets',
              style: Styles.headLineStyle1,
            ),
            Gap(AppLayout.getHeight(10)),
            Text(
              'Search for flights and book your next trip!',
              style: Styles.headLineStyle4,
              textAlign: TextAlign.center,
            ),
            Gap(AppLayout.getHeight(30)),
            ElevatedButton(
              onPressed: () {
                // Navigate to search screen (index 1 in bottom bar)
                // In a real app, you would use Get.to() or similar
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Styles.primaryColor,
                padding: EdgeInsets.symmetric(
                  horizontal: AppLayout.getWidth(30),
                  vertical: AppLayout.getHeight(15),
                ),
              ),
              child: Text(
                'Search Flights',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
