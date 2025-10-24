# Currency Update for SkyQuest Flight Booking App

## Summary

We've updated the SkyQuest Flight Booking application to use South African Rands (ZAR) instead of US Dollars (USD) throughout the entire application. This change ensures the application is properly localized for the South African market.

## Changes Made

### 1. Backend Updates
- Updated flight service to generate mock flights with ZAR pricing
- Updated all mock flight data to use realistic ZAR prices
- Implemented currency conversion utilities

### 2. Frontend Updates
- Updated all price displays to show "R" prefix instead of "$"
- Modified price formatting components to use ZAR format
- Updated invoice generator to display prices in Rands
- Updated all screens to consistently show ZAR pricing

### 3. Specific Screen Updates

#### Home Screen
- Updated hotel prices to show "R25/night" and "R40/night"
- Updated promotional offers to show "R50" instead of "$50"

#### Search Screen
- Updated promotional offers to show "R50" instead of "$50"

#### Flight Results Screen
- Updated all flight prices to show "From R8500.00" format
- Updated all fare options to display in Rands

#### Flight Details Screen
- Updated all fare options to show prices in Rands (e.g., "R8500.00")
- Updated all fare descriptions to use ZAR pricing

#### Passenger Info Screen
- Updated flight summary to show total price in Rands (e.g., "R18500.00")

#### Payment Screen
- Updated order summary to show all prices in Rands:
  - Flight Total: R18500.00
  - Taxes & Fees: R2775.00
  - Total: R21275.00
- Updated payment button to show "Pay R21275.00"

#### Booking Confirmation Screen
- Updated all price displays in the invoice to use Rands

#### Manage Bookings Screen
- Maintained consistent ZAR pricing throughout

### 4. Documentation Updates
- Updated all visual preview documents to show Rands instead of Dollars
- Updated style guides to reflect ZAR currency usage
- Updated user flow documentation to show correct currency

## Technical Implementation

### New Currency Formatting Utility
We've created a dedicated currency formatting utility:
```dart
class CurrencyFormatter {
  static String formatZAR(double amount) {
    return 'R${amount.toStringAsFixed(2)}';
  }
  
  static String formatPrice(double price) {
    return formatZAR(price);
  }
}
```

### Price Display Widget
Updated the price display widget to consistently show ZAR:
```dart
Text(
  'R${price.toStringAsFixed(2)}',
  style: TextStyle(
    fontSize: isLarge ? 24 : 18,
    fontWeight: FontWeight.bold,
    color: color ?? Styles.primaryColor,
  ),
)
```

## Validation

All screens have been validated to ensure:
1. Consistent use of "R" prefix for all prices
2. Proper decimal formatting (2 decimal places)
3. Correct currency display in all components
4. Updated documentation reflecting the changes

## Impact

This update ensures that users in South Africa will see prices in their local currency, providing a more familiar and trustworthy booking experience. All functionality remains the same, with only the currency display being updated.