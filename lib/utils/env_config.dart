/// Environment configuration file for API keys and other sensitive data
/// 
/// In a production environment, these values should be:
/// 1. Stored in environment variables
/// 2. Loaded from a secure configuration service
/// 3. Never committed to version control
///
/// For development and testing purposes, you can use placeholder values
/// but remember to replace them with actual keys before deployment.

class EnvConfig {
  // SerpApi Configuration
  static const String serpApiKey = 'YOUR_SERPAPI_KEY_HERE';
  
  // Paystack Configuration
  static const String paystackPublicKey = 'pk_test_your_paystack_public_key_here';
  static const String paystackSecretKey = 'sk_test_your_paystack_secret_key_here';
  
  // App Configuration
  static const String appName = 'SkyQuest';
  static const String appVersion = '1.0.0';
  
  // API Endpoints
  static const String serpApiBaseUrl = 'https://serpapi.com/search';
  static const String paystackApiBaseUrl = 'https://api.paystack.co';
  
  // Currency Configuration
  static const String currencyCode = 'ZAR';
  static const String currencySymbol = 'R';
  
  // Payment Configuration
  static const bool enableTestMode = true; // Set to false for production
  static const String paymentSuccessRedirectUrl = 'https://yourdomain.com/payment-success';
  static const String paymentCancelRedirectUrl = 'https://yourdomain.com/payment-cancel';
}