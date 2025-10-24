import 'package:paystack_payment/paystack_payment.dart';

class PaymentService {
  static const String paystackPublicKey = 'pk_test_your_paystack_public_key_here';
  
  static void initialize() {
    PaystackPlugin.initialize(publicKey: paystackPublicKey);
  }

  /// Initialize Paystack payment
  static Future<bool> initializePayment({
    required double amount,
    required String email,
    String? reference,
  }) async {
    try {
      // Convert amount to kobo (smallest currency unit)
      final int amountInKobo = (amount * 100).toInt();
      
      final charge = Charge()
        ..amount = amountInKobo
        ..reference = reference ?? _generateReference()
        ..email = email;
      
      final response = await PaystackPlugin.checkout(
        charge,
        method: CheckoutMethod.selectable,
        fullscreen: false,
        logo: Container(
          height: 50,
          width: 50,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/app_logo.png'),
            ),
          ),
        ),
      );
      
      // Check if payment was successful
      if (response.status == true) {
        return true;
      }
      
      return false;
    } catch (e) {
      // In case of error, return false
      return false;
    }
  }

  /// Generate a unique reference for the transaction
  static String _generateReference() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'SQ_${timestamp}';
  }

  /// Process QR code payment
  static Future<bool> processQRPayment({
    required double amount,
    required String email,
  }) async {
    try {
      // For QR code payment, we would typically generate a QR code
      // and then process the payment when scanned
      // This is a simplified implementation
      
      // In a real implementation, you would:
      // 1. Generate a payment request to Paystack
      // 2. Get a QR code URL or data
      // 3. Display the QR code to the user
      // 4. Poll for payment confirmation
      
      // For now, we'll simulate a successful QR payment
      await Future.delayed(const Duration(seconds: 3));
      return true;
    } catch (e) {
      return false;
    }
  }
}