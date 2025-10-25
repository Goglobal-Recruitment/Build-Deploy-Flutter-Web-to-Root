import 'package:booktickets/models/flight.dart';
import 'package:booktickets/utils/app_layout.dart';
import 'package:booktickets/utils/app_styles.dart';
import 'package:booktickets/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class PassengerInfoScreen extends StatefulWidget {
  final Flight flight;
  final FareOption selectedFare;
  final int passengerCount;

  const PassengerInfoScreen({
    Key? key,
    required this.flight,
    required this.selectedFare,
    required this.passengerCount,
  }) : super(key: key);

  @override
  State<PassengerInfoScreen> createState() => _PassengerInfoScreenState();
}

class _PassengerInfoScreenState extends State<PassengerInfoScreen> {
  final List<Map<String, TextEditingController>> _passengersControllers = [];
  final List<GlobalKey<FormState>> _formKeys = [];

  @override
  void initState() {
    super.initState();
    // Initialize controllers for each passenger
    for (int i = 0; i < widget.passengerCount; i++) {
      _passengersControllers.add({
        'firstName': TextEditingController(),
        'lastName': TextEditingController(),
        'dateOfBirth': TextEditingController(),
        'email': TextEditingController(),
        'phone': TextEditingController(),
      });
      _formKeys.add(GlobalKey<FormState>());
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var controllers in _passengersControllers) {
      for (var controller in controllers.values) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  void _proceedToPayment() {
    bool isValid = true;
    // Validate all forms
    for (var key in _formKeys) {
      if (!(key.currentState?.validate() ?? false)) {
        isValid = false;
      }
    }

    if (isValid) {
      // Collect passenger data
      final passengers = <Map<String, String>>[];
      for (var controllers in _passengersControllers) {
        passengers.add({
          'firstName': controllers['firstName']!.text,
          'lastName': controllers['lastName']!.text,
          'dateOfBirth': controllers['dateOfBirth']!.text,
          'email': controllers['email']!.text,
          'phone': controllers['phone']!.text,
        });
      }

      // Navigate to payment screen
      Get.toNamed(
        '/payment',
        arguments: {
          'flight': widget.flight,
          'selectedFare': widget.selectedFare,
          'passengers': passengers,
        },
      );
    }
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 12)),
    );
    if (picked != null) {
      controller.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = widget.selectedFare.price * widget.passengerCount;

    return Scaffold(
      backgroundColor: Styles.bgColor,
      appBar: AppBar(
        backgroundColor: Styles.secondaryColor,
        title: Text(
          'Passenger Information',
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
            // Flight summary
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
                    'Flight Summary',
                    style: Styles.headLineStyle2,
                  ),
                  Gap(AppLayout.getHeight(10)),
                  
                  Text(
                    '${widget.flight.originCode} → ${widget.flight.destinationCode}',
                    style: Styles.headLineStyle3,
                  ),
                  Text(
                    widget.flight.departureTime.formatDate(),
                    style: Styles.headLineStyle4,
                  ),
                  Text(
                    '${widget.passengerCount} Passenger${widget.passengerCount > 1 ? 's' : ''} • ${widget.selectedFare.type} Fare',
                    style: Styles.headLineStyle4,
                  ),
                  Gap(AppLayout.getHeight(10)),
                  Text(
                    'R${totalPrice.toStringAsFixed(2)}',
                    style: Styles.headLineStyle1.copyWith(
                      color: Styles.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            
            // Passenger forms
            for (int i = 0; i < widget.passengerCount; i++)
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: AppLayout.getWidth(20),
                  vertical: AppLayout.getHeight(10),
                ),
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
                      'Passenger ${i + 1}',
                      style: Styles.headLineStyle2,
                    ),
                    Gap(AppLayout.getHeight(15)),
                    
                    Form(
                      key: _formKeys[i],
                      child: Column(
                        children: [
                          // First name
                          TextFormField(
                            controller: _passengersControllers[i]['firstName'],
                            decoration: const InputDecoration(
                              labelText: 'First Name *',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter first name';
                              }
                              return null;
                            },
                          ),
                          Gap(AppLayout.getHeight(15)),
                          
                          // Last name
                          TextFormField(
                            controller: _passengersControllers[i]['lastName'],
                            decoration: const InputDecoration(
                              labelText: 'Last Name *',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter last name';
                              }
                              return null;
                            },
                          ),
                          Gap(AppLayout.getHeight(15)),
                          
                          // Date of birth
                          TextFormField(
                            controller: _passengersControllers[i]['dateOfBirth'],
                            decoration: InputDecoration(
                              labelText: 'Date of Birth *',
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.calendar_today),
                                onPressed: () => _selectDate(
                                  context,
                                  _passengersControllers[i]['dateOfBirth']!,
                                ),
                              ),
                            ),
                            readOnly: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select date of birth';
                              }
                              return null;
                            },
                          ),
                          Gap(AppLayout.getHeight(15)),
                          
                          // Email
                          TextFormField(
                            controller: _passengersControllers[i]['email'],
                            decoration: const InputDecoration(
                              labelText: 'Email Address *',
                              prefixIcon: const Icon(Icons.email),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter email address';
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          Gap(AppLayout.getHeight(15)),
                          
                          // Phone
                          TextFormField(
                            controller: _passengersControllers[i]['phone'],
                            decoration: const InputDecoration(
                              labelText: 'Phone Number *',
                              prefixIcon: const Icon(Icons.phone),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter phone number';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            
            // Proceed to payment button
            Container(
              margin: EdgeInsets.all(AppLayout.getWidth(20)),
              child: CustomButton(
                text: 'Proceed to Payment',
                onPressed: _proceedToPayment,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on DateTime {
  String formatTime() {
    return '${this.hour.toString().padLeft(2, '0')}:${this.minute.toString().padLeft(2, '0')}';
  }
  
  String formatDate() {
    return '${this.day.toString().padLeft(2, '0')}/${this.month.toString().padLeft(2, '0')}/${this.year}';
  }
}