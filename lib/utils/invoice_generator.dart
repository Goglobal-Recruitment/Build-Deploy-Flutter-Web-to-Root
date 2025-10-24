class InvoiceGenerator {
  static String generateInvoiceHtml({
    required String bookingReference,
    required String bookingDate,
    required String originCode,
    required String destinationCode,
    required String departureTime,
    required String arrivalTime,
    required String airlineName,
    required String flightNumber,
    required String duration,
    required String fareType,
    required double farePrice,
    required int passengerCount,
    required List<Map<String, String>> passengers,
    required double totalPrice,
  }) {
    final subtotal = farePrice * passengerCount;
    final taxes = subtotal * 0.15;
    final total = subtotal + taxes;

    final passengerRows = passengers.map((passenger) {
      return '''
      <tr>
        <td>${passenger['name']}</td>
        <td>${passenger['dob']}</td>
        <td>${passenger['email']}</td>
        <td>${passenger['phone']}</td>
      </tr>
      ''';
    }).join('');

    return '''
<!DOCTYPE html>
<html>
<head>
    <title>Invoice - \$bookingReference</title>
    <style>
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            margin: 0; 
            padding: 40px; 
            background-color: #f8f9fa;
        }
        .invoice-container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .header {
            background: linear-gradient(135deg, #1D6ED6 0%, #0E2D5D 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        .header h1 {
            margin: 0;
            font-size: 28px;
        }
        .header p {
            margin: 5px 0 0;
            opacity: 0.9;
        }
        .booking-info {
            display: flex;
            justify-content: space-between;
            padding: 20px 30px;
            background: #f1f5fd;
            border-bottom: 1px solid #e2e8f0;
        }
        .booking-info div {
            text-align: center;
        }
        .booking-info h3 {
            margin: 0 0 5px 0;
            color: #1D6ED6;
            font-size: 16px;
        }
        .booking-info p {
            margin: 0;
            font-weight: bold;
            font-size: 18px;
        }
        .content {
            padding: 30px;
        }
        .section {
            margin-bottom: 30px;
        }
        .section h2 {
            color: #0E2D5D;
            border-bottom: 2px solid #1D6ED6;
            padding-bottom: 10px;
            margin-top: 0;
        }
        .flight-details {
            display: flex;
            justify-content: space-between;
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .flight-segment {
            text-align: center;
        }
        .flight-segment .time {
            font-size: 24px;
            font-weight: bold;
            color: #0E2D5D;
        }
        .flight-segment .code {
            font-size: 18px;
            color: #4a5568;
        }
        .flight-duration {
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            color: #718096;
        }
        .flight-icon {
            font-size: 24px;
            margin: 10px 0;
            color: #1D6ED6;
        }
        .flight-airline {
            background: #ebf8ff;
            padding: 10px;
            border-radius: 5px;
            text-align: center;
            margin-top: 15px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 15px 0;
        }
        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
        }
        th {
            background-color: #1D6ED6;
            color: white;
            font-weight: 600;
        }
        tr:hover {
            background-color: #f7fafc;
        }
        .price-breakdown {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
        }
        .price-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
        }
        .price-row.total {
            border-top: 2px solid #e2e8f0;
            margin-top: 10px;
            padding-top: 15px;
            font-weight: bold;
            font-size: 18px;
            color: #0E2D5D;
        }
        .footer {
            text-align: center;
            padding: 20px;
            background: #f1f5fd;
            color: #4a5568;
            font-size: 14px;
        }
        @media print {
            body {
                background: white;
                padding: 0;
            }
            .invoice-container {
                box-shadow: none;
            }
        }
    </style>
</head>
<body>
    <div class="invoice-container">
        <div class="header">
            <h1>SkyQuest Airlines</h1>
            <p>Booking Confirmation & Invoice</p>
        </div>
        
        <div class="booking-info">
            <div>
                <h3>BOOKING REFERENCE</h3>
                <p>\$bookingReference</p>
            </div>
            <div>
                <h3>BOOKING DATE</h3>
                <p>\$bookingDate</p>
            </div>
            <div>
                <h3>STATUS</h3>
                <p>CONFIRMED</p>
            </div>
        </div>
        
        <div class="content">
            <div class="section">
                <h2>Flight Details</h2>
                <div class="flight-details">
                    <div class="flight-segment">
                        <div class="time">\$departureTime</div>
                        <div class="code">\$originCode</div>
                    </div>
                    <div class="flight-duration">
                        <div>\$duration</div>
                        <div class="flight-icon">✈️</div>
                        <div>Direct</div>
                    </div>
                    <div class="flight-segment">
                        <div class="time">\$arrivalTime</div>
                        <div class="code">\$destinationCode</div>
                    </div>
                </div>
                <div class="flight-airline">
                    \$airlineName • \$flightNumber
                </div>
            </div>
            
            <div class="section">
                <h2>Passenger Information</h2>
                <table>
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Date of Birth</th>
                            <th>Email</th>
                            <th>Phone</th>
                        </tr>
                    </thead>
                    <tbody>
                        \$passengerRows
                    </tbody>
                </table>
            </div>
            
            <div class="section">
                <h2>Price Breakdown</h2>
                <div class="price-breakdown">
                    <div class="price-row">
                        <span>Flight Fare (\$fareType)</span>
                        <span>\$${farePrice.toStringAsFixed(2)}</span>
                    </div>
                    <div class="price-row">
                        <span>Passengers</span>
                        <span>\$passengerCount</span>
                    </div>
                    <div class="price-row">
                        <span>Subtotal</span>
                        <span>\$${subtotal.toStringAsFixed(2)}</span>
                    </div>
                    <div class="price-row">
                        <span>Taxes & Fees (15%)</span>
                        <span>\$${taxes.toStringAsFixed(2)}</span>
                    </div>
                    <div class="price-row total">
                        <span>Total</span>
                        <span>\$${total.toStringAsFixed(2)}</span>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="footer">
            <p>Thank you for choosing SkyQuest Airlines!</p>
            <p>For assistance, contact support@skyquest.com | www.skyquest.com</p>
        </div>
    </div>
</body>
</html>
    ''';
  }
}