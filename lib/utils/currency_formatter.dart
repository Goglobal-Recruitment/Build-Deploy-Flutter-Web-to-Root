class CurrencyFormatter {
  static String formatZAR(double amount) {
    return 'R${amount.toStringAsFixed(2)}';
  }
  
  static String formatPrice(double price) {
    return formatZAR(price);
  }
  
  // Convert USD to ZAR (approximate exchange rate for demo purposes)
  static double convertUSDToZAR(double usdAmount) {
    // Using approximate exchange rate: 1 USD = 18 ZAR
    // This is for demonstration purposes only
    return usdAmount * 18.0;
  }
}