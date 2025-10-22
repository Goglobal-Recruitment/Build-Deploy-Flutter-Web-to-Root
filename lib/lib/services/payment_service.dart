import 'package:flutter/material.dart';
import 'package:paystack_payment/paystack_payment.dart';
import '../api_keys.dart';

class PaymentService {
  static void initialize() {
    PaystackPlugin.initialize(publicKey: ApiKeys.paystackPublicKey);
  }

  static Future<void> makePayment(
    BuildContext context, {
    required int amount, // amount in kobo (e.g., 5000 = ₦50)
    required String email,
    String currency = 'NGN',
  }) async {
    try {
      Charge charge = Charge()
        ..amount = amount
        ..email = email
        ..currency = currency
        ..reference = DateTime.now().millisecondsSinceEpoch.toString();

      CheckoutResponse response = await PaystackPlugin.checkout(
        context,
        charge: charge,
        method: CheckoutMethod.card,
      );

      if (response.status) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Payment successful!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Payment cancelled or failed.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Payment error: $e")),
      );
    }
  }
}
