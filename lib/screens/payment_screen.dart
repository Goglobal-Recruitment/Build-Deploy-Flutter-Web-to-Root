import 'package:booktickets/models/booking.dart';
import 'package:booktickets/utils/app_layout.dart';
import 'package:booktickets/utils/app_styles.dart';
import 'package:booktickets/widgets/custom_app_bar.dart';
import 'package:booktickets/widgets/custom_button.dart';
import 'package:booktickets/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'booking_confirmation_screen.dart';

class PaymentScreen extends StatefulWidget {
  final Booking booking;

  const PaymentScreen({Key? key, required this.booking}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill with sample data for demo
    _cardNumberController.text = "4242 4242 4242 4242";
    _expiryController.text = "12/25";
    _cvvController.text = "123";
    _cardHolderController.text = "John Doe";
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardHolderController.dispose();
    super.dispose();
  }

  void _processPayment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // Show success and navigate to confirmation
    Get.snackbar(
      "Payment Successful",
      "Your payment has been processed successfully",
      backgroundColor: Styles.successColor,
      colorText: Colors.white,
    );

    // Navigate to confirmation screen
    Get.offAll(() => BookingConfirmationScreen(booking: widget.booking));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.bgColor,
      appBar: CustomAppBar(
        title: 'Payment',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Booking summary
            _buildBookingSummary(),
            Gap(AppLayout.getHeight(20)),
            
            // Payment form
            _buildPaymentForm(),
            Gap(AppLayout.getHeight(20)),
            
            // Payment button
            Container(
              padding: EdgeInsets.all(AppLayout.getWidth(20)),
              child: CustomButton(
                onPressed: _isLoading ? null : _processPayment,
                text: 'Pay \$${widget.booking.totalPrice.toStringAsFixed(2)}',
                isLoading: _isLoading,
              ),
            ),
            
            // Security notice
            Container(
              padding: EdgeInsets.symmetric(horizontal: AppLayout.getWidth(20)),
              child: Text(
                '🔒 Your payment details are securely encrypted and processed. We do not store your card information.',
                style: Styles.headLineStyle4.copyWith(
                  color: Styles.textLightColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingSummary() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: Styles.headLineStyle2,
          ),
          Gap(AppLayout.getHeight(15)),
          
          // Flight details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.booking.flight.originCode} → ${widget.booking.flight.destinationCode}',
                style: Styles.headLineStyle3,
              ),
              Text(
                '${widget.booking.flight.departureTime.formatDate()}',
                style: Styles.headLineStyle4,
              ),
            ],
          ),
          Gap(AppLayout.getHeight(5)),
          
          // Passenger count
          Text(
            '${widget.booking.passengers.length} Passenger${widget.booking.passengers.length > 1 ? 's' : ''}',
            style: Styles.headLineStyle4,
          ),
          Gap(AppLayout.getHeight(5)),
          
          // Fare type
          Text(
            '${widget.booking.selectedFare.type} Fare',
            style: Styles.headLineStyle4,
          ),
          Gap(AppLayout.getHeight(10)),
          
          // Price breakdown
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Flight Total', style: Styles.headLineStyle4),
              Text(
                '\$${widget.booking.totalPrice.toStringAsFixed(2)}',
                style: Styles.headLineStyle4,
              ),
            ],
          ),
          Gap(AppLayout.getHeight(5)),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Taxes & Fees', style: Styles.headLineStyle4),
              Text('\$${(widget.booking.totalPrice * 0.15).toStringAsFixed(2)}', style: Styles.headLineStyle4),
            ],
          ),
          Gap(AppLayout.getHeight(5)),
          
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: Styles.headLineStyle3.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${(widget.booking.totalPrice * 1.15).toStringAsFixed(2)}',
                style: Styles.headLineStyle1.copyWith(
                  color: Styles.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentForm() {
    return CustomCard(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Details',
              style: Styles.headLineStyle2,
            ),
            Gap(AppLayout.getHeight(15)),
            
            // Card number
            TextFormField(
              controller: _cardNumberController,
              decoration: const InputDecoration(
                labelText: 'Card Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.credit_card),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter card number';
                }
                if (value.length < 16) {
                  return 'Please enter a valid card number';
                }
                return null;
              },
            ),
            Gap(AppLayout.getHeight(10)),
            
            // Expiry and CVV
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _expiryController,
                    decoration: const InputDecoration(
                      labelText: 'Expiry (MM/YY)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter expiry date';
                      }
                      if (!RegExp(r'^(0[1-9]|1[0-2])\/?([0-9]{2})$').hasMatch(value)) {
                        return 'Invalid format';
                      }
                      return null;
                    },
                  ),
                ),
                Gap(AppLayout.getWidth(10)),
                Expanded(
                  child: TextFormField(
                    controller: _cvvController,
                    decoration: const InputDecoration(
                      labelText: 'CVV',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter CVV';
                      }
                      if (value.length < 3) {
                        return 'Invalid CVV';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            Gap(AppLayout.getHeight(10)),
            
            // Card holder name
            TextFormField(
              controller: _cardHolderController,
              decoration: const InputDecoration(
                labelText: 'Cardholder Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter cardholder name';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}

extension on DateTime {
  String formatDate() {
    return '${this.day}/${this.month}/${this.year}';
  }
}