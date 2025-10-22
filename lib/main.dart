import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:booktickets/screens/bottom_bar.dart';
import 'package:booktickets/utils/app_styles.dart';
import 'package:booktickets/services/payment_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Paystack before app runs
  PaymentService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Go Global Flights',
      theme: ThemeData(
        primaryColor: primary,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: primary),
      ),
      home: const BottomBar(),
    );
  }
}
