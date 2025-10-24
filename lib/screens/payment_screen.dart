import 'package:booktickets/models/booking.dart';
import 'package:booktickets/models/flight.dart';
import 'package:booktickets/services/flight_service.dart';
import 'package:booktickets/utils/app_layout.dart';
import 'package:booktickets/utils/app_styles.dart';
import 'package:booktickets/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class PaymentScreen extends StatefulWidget {
  final Flight flight;
  final FareOption selectedFare;
  final List<Map<String, String>> passengers;

  const PaymentScreen({
    Key? key,
    required this.flight,
    required this.selectedFare,
    required this.passengers,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardholderController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardholderController.dispose();
    super.dispose();
  }

  void _processPayment() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate payment processing
      Future.delayed(const Duration(seconds: 2), () {
        // Create booking
        final passengerObjects = widget.passengers.map((passengerData) {
          return Passenger(
            id: '',
            firstName: passengerData['firstName']!,
            lastName: passengerData['lastName']!,
            dateOfBirth: DateTime.parse(passengerData['dateOfBirth']!),
            email: passengerData['email']!,
            phone: passengerData['phone']!,
          );
        }).toList();

        final booking = FlightService().createBooking(
          flight: widget.flight,
          selectedFare: widget.selectedFare,
          passengers: passengerObjects,
        );

        setState(() {
          _isLoading = false;
        });

        // Navigate to confirmation screen
        Get.offAllNamed(
          '/booking-confirmation',
          arguments: booking,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = widget.selectedFare.price * widget.passengers.length;
    final taxes = subtotal * 0.15; // 15% tax
    final total = subtotal + taxes;

    return Scaffold(
      backgroundColor: Styles.bgColor,
      appBar: AppBar(
        backgroundColor: Styles.secondaryColor,
        title: Text(
          'Payment',
          style: Styles.headLineStyle1.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Order summary
            Container(
              margin: EdgeInsets.all(AppLayout.getHeight(20)),
              padding: EdgeInsets.all(AppLayout.getHeight(20)),
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
                  Text(
                    'Order Summary',
                    style: Styles.headLineStyle2,
                  ),
                  Gap(AppLayout.getHeight(15)),
                  
                  Text(
                    '${widget.flight.originCode} → ${widget.flight.destinationCode}',
                    style: Styles.headLineStyle3,
                  ),
                  Text(
                    widget.flight.departureTime.formatDate(),
                    style: Styles.headLineStyle4,
                  ),
                  Text(
                    '${widget.passengers.length} Passenger${widget.passengers.length > 1 ? 's' : ''} • ${widget.selectedFare.type} Fare',
                    style: Styles.headLineStyle4,
                  ),
                  Gap(AppLayout.getHeight(15)),
                  
                  // Price breakdown
                  Container(
                    padding: EdgeInsets.all(AppLayout.getWidth(10)),
                    decoration: BoxDecoration(
                      color: Styles.accentColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppLayout.getHeight(5)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Flight Total',
                              style: Styles.headLineStyle3,
                            ),
                            Text(
                              'R${subtotal.toStringAsFixed(2)}',
                              style: Styles.headLineStyle3,
                            ),
                          ],
                        ),
                        Gap(AppLayout.getHeight(5)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Taxes & Fees',
                              style: Styles.headLineStyle3,
                            ),
                            Text(
                              'R${taxes.toStringAsFixed(2)}',
                              style: Styles.headLineStyle3,
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: Styles.headLineStyle1.copyWith(
                                color: Styles.primaryColor,
                              ),
                            ),
                            Text(
                              'R${total.toStringAsFixed(2)}',
                              style: Styles.headLineStyle1.copyWith(
                                color: Styles.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Payment form
            Container(
              margin: EdgeInsets.symmetric(horizontal: AppLayout.getWidth(20)),
              padding: EdgeInsets.all(AppLayout.getHeight(20)),
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
                        labelText: 'Card Number *',
                        prefixIcon: Icon(Icons.credit_card),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter card number';
                        }
                        return null;
                      },
                    ),
                    Gap(AppLayout.getHeight(15)),
                    
                    // Expiry and CVV
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _expiryController,
                            decoration: const InputDecoration(
                              labelText: 'Expiry (MM/YY) *',
                            ),
                            keyboardType: TextInputType.datetime,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter expiry date';
                              }
                              return null;
                            },
                          ),
                        ),
                        Gap(AppLayout.getWidth(15)),
                        Expanded(
                          child: TextFormField(
                            controller: _cvvController,
                            decoration: const InputDecoration(
                              labelText: 'CVV *',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter CVV';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    Gap(AppLayout.getHeight(15)),
                    
                    // Cardholder name
                    TextFormField(
                      controller: _cardholderController,
                      decoration: const InputDecoration(
                        labelText: 'Cardholder Name *',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter cardholder name';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            Gap(AppLayout.getHeight(20)),
            
            // Pay button
            Container(
              margin: EdgeInsets.all(AppLayout.getWidth(20)),
              child: CustomButton(
                text: _isLoading 
                    ? 'Processing Payment...' 
                    : 'Pay R${total.toStringAsFixed(2)}',
                onPressed: _isLoading ? null : _processPayment,
              ),
            ),
            
            // Security notice
            Container(
              margin: EdgeInsets.symmetric(horizontal: AppLayout.getWidth(20)),
              padding: EdgeInsets.all(AppLayout.getWidth(15)),
              decoration: BoxDecoration(
                color: Styles.accentColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppLayout.getHeight(10)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.lock,
                    color: Colors.green,
                  ),
                  Gap(AppLayout.getWidth(10)),
                  Expanded(
                    child: Text(
                      'Your payment details are securely encrypted and processed. We do not store your card information.',
                      style: Styles.headLineStyle4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on DateTime {
  String formatDate() {
    return '${this.day.toString().padLeft(2, '0')}/${this.month.toString().padLeft(2, '0')}/${this.year}';
  }
}