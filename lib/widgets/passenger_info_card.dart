import 'package:booktickets/models/booking.dart';
import 'package:booktickets/utils/app_layout.dart';
import 'package:booktickets/utils/app_styles.dart';
import 'package:booktickets/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PassengerInfoCard extends StatelessWidget {
  final Passenger passenger;

  const PassengerInfoCard({
    Key? key,
    required this.passenger,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person),
              Gap(AppLayout.getWidth(10)),
              Text(
                passenger.fullName,
                style: Styles.headLineStyle3,
              ),
            ],
          ),
          Gap(AppLayout.getHeight(10)),
          _buildInfoRow('Date of Birth', passenger.dateOfBirth.formatDate()),
          Gap(AppLayout.getHeight(5)),
          _buildInfoRow('Email', passenger.email),
          Gap(AppLayout.getHeight(5)),
          _buildInfoRow('Phone', passenger.phone),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: AppLayout.getWidth(100),
          child: Text(
            label,
            style: Styles.headLineStyle4,
          ),
        ),
        Text(
          ': ',
          style: Styles.headLineStyle4,
        ),
        Expanded(
          child: Text(
            value,
            style: Styles.headLineStyle4,
          ),
        ),
      ],
    );
  }
}

extension on DateTime {
  String formatDate() {
    return '${this.day.toString().padLeft(2, '0')}/${this.month.toString().padLeft(2, '0')}/${this.year}';
  }
}