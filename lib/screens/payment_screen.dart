import 'package:booktickets/models/booking.dart';
import 'package:booktickets/models/flight.dart';
import 'package:booktickets/services/flight_service.dart';
import 'package:booktickets/services/payment_service.dart';
import 'package:booktickets/utils/app_layout.dart';
import 'package:booktickets/utils/app_styles.dart';
import 'package:booktickets/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:barcode_widget/barcode_widget.dart';

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
  final _emailController = TextEditingController();

  bool _isLoading = false;
  bool _showQRCode = false;
  String _paymentReference = '';

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardholderController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _processCardPayment() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final subtotal = widget.selectedFare.price * widget.passengers.length;
      final taxes = subtotal * 0.15; // 15% tax
      final total = subtotal + taxes;

      // Process payment with Paystack
      final paymentSuccess = await PaymentService.initializePayment(
        amount: total,
        email: _emailController.text,
      );

      if (paymentSuccess) {
        _createBooking();
      } else {
        setState(() {
          _isLoading = false;
        });
        
        // Show error message
        Get.snackbar(
          'Payment Failed',
          'Your payment could not be processed. Please try again.',
          backgroundColor: Styles.errorColor,
          colorText: Colors.white,
        );
      }
    }
  }

  void _processQRPayment() async {
    setState(() {
      _isLoading = true;
      _showQRCode = true;
    });

    final subtotal = widget.selectedFare.price * widget.passengers.length;
    final taxes = subtotal * 0.15; // 15% tax
    final total = subtotal + taxes;

    // Process QR payment
    final paymentSuccess = await PaymentService.processQRPayment(
      amount: total,
      email: _emailController.text,
    );

    if (paymentSuccess) {
      _createBooking();
    } else {
      setState(() {
        _isLoading = false;
        _showQRCode = false;
      });
      
      // Show error message
      Get.snackbar(
        'Payment Failed',
        'Your QR payment could not be processed. Please try again.',
        backgroundColor: Styles.errorColor,
        colorText: Colors.white,
      );
    }
  }

  void _createBooking() {
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
            
            // Payment method selection
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Method',
                    style: Styles.headLineStyle2,
                  ),
                  Gap(AppLayout.getHeight(15)),
                  
                  // Email for payment
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email Address *',
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email address';
                      }
                      if (!GetUtils.isEmail(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  Gap(AppLayout.getHeight(15)),
                  
                  // Payment method buttons
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Pay with Card',
                          onPressed: _isLoading ? null : _processCardPayment,
                        ),
                      ),
                      Gap(AppLayout.getWidth(10)),
                      Expanded(
                        child: CustomButton(
                          text: 'QR Payment',
                          backgroundColor: Styles.secondaryColor,
                          onPressed: _isLoading ? null : _processQRPayment,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // QR Code display
            if (_showQRCode)
              Container(
                margin: EdgeInsets.all(AppLayout.getWidth(20)),
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
                  children: [
                    Text(
                      'Scan QR Code to Pay',
                      style: Styles.headLineStyle2,
                    ),
                    Gap(AppLayout.getHeight(15)),
                    // QR Code for payment
                    BarcodeWidget(
                      barcode: Barcode.qrCode(),
                      data: 'payment_reference:$_paymentReference|amount:$total|email:${_emailController.text}',
                      width: 200,
                      height: 200,
                    ),
                    Gap(AppLayout.getHeight(15)),
                    Text(
                      'Scan this QR code with your banking app to complete payment of R${total.toStringAsFixed(2)}',
                      textAlign: TextAlign.center,
                      style: Styles.headLineStyle4,
                    ),
                  ],
                ),
              ),
            
            // Card payment form (only shown when not using QR)
            if (!_showQRCode)
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
                        'Card Details',
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
            
            // Pay button (only shown when not using QR)
            if (!_showQRCode)
              Container(
                margin: EdgeInsets.all(AppLayout.getWidth(20)),
                child: CustomButton(
                  text: _isLoading 
                      ? 'Processing Payment...' 
                      : 'Pay R${total.toStringAsFixed(2)}',
                  onPressed: _isLoading ? null : _processCardPayment,
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