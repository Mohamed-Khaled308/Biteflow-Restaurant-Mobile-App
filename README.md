# BiteFlow - Advanced Restaurant Management System

## Overview

BiteFlow is an innovative restaurant management platform built with Flutter that revolutionizes the dining experience. It combines powerful features like real-time payment processing through Stripe, collaborative dining with QR code table sharing, and comprehensive restaurant management capabilities.

## Table of Contents
- [Key Features](#key-features)
- [Technical Architecture](#technical-architecture)
- [Implementation Details](#implementation-details)
- [Installation Guide](#installation-guide)
- [Configuration](#configuration)
- [Usage Guide](#usage-guide)
- [API Documentation](#api-documentation)
- [Contributing](#contributing)
- [License](#license)

## Key Features

### Advanced Payment Processing
- **Stripe Integration**
  - Real-time payment processing
  - Secure payment handling
  - Multiple payment methods support
  - Transaction history tracking
  - Payment status monitoring

### Collaborative Dining
- **QR Code Integration**
  - Dynamic QR code generation
  - Instant table joining
  - Real-time order synchronization
  - Group order management
  - Split bill functionality

### Bill Splitting System
- **Multiple Splitting Methods**
  - Equal split functionality
  - Item-based splitting
  - Percentage-based division
  - Individual payment tracking
  - Split history maintenance

### Restaurant Management
- **Menu Management**
  - Dynamic category organization
  - Real-time menu updates
  - Image management
  - Price control
  - Item availability tracking

### Order Processing
- **Real-time Order Management**
  - Live order tracking
  - Status updates
  - Kitchen notifications
  - Order history
  - Special instructions handling

### Marketing Tools
- **Promotional Management**
  - Offer creation
  - Campaign tracking
  - Customer targeting
  - Discount management
  - Performance analytics

## Technical Architecture

### Core Technologies
```
Frontend:
- Flutter Framework
- Provider State Management
- GetIt Dependency Injection
- Custom Theme System

Backend:
- Firebase Authentication
- Cloud Firestore
- Firebase Cloud Functions
- Firebase Cloud Messaging
- Firebase Storage

Payment Processing:
- Stripe SDK Integration
- Secure Payment Gateway
- Transaction Management
```

### Project Structure
```
lib/
├── core/
│   ├── constants/
│   │   ├── api_constants.dart
│   │   ├── theme_constants.dart
│   │   └── business_constants.dart
│   ├── providers/
│   │   ├── user_provider.dart
│   │   └── theme_provider.dart
│   └── utils/
│       ├── validators.dart
│       └── helpers.dart
├── models/
│   ├── user/
│   │   ├── client.dart
│   │   └── manager.dart
│   ├── order/
│   │   ├── order.dart
│   │   └── order_item.dart
│   └── payment/
│       ├── payment_intent.dart
│       └── transaction.dart
├── services/
│   ├── auth/
│   │   └── auth_service.dart
│   ├── payment/
│   │   └── stripe_service.dart
│   └── firestore/
│       ├── order_service.dart
│       └── restaurant_service.dart
├── viewmodels/
│   ├── auth/
│   ├── payment/
│   └── order/
├── views/
│   ├── screens/
│   │   ├── auth/
│   │   ├── payment/
│   │   └── order/
│   └── widgets/
│       ├── common/
│       └── payment/
└── main.dart
```

## Implementation Details

### Payment Integration
```dart
class PaymentService {
  Future<PaymentIntent> createPaymentIntent(double amount) async {
    try {
      final response = await _stripe.createPaymentIntent(
        amount: amount.toInt() * 100,
        currency: 'USD',
        paymentMethodTypes: ['card'],
      );
      return PaymentIntent.fromJson(response.data);
    } catch (e) {
      throw PaymentException(message: 'Failed to create payment intent');
    }
  }
}
```

### QR Code Implementation
```dart
class QRCodeService {
  String generateOrderQR(String orderId) {
    final data = {
      'orderId': orderId,
      'timestamp': DateTime.now().toIso8601String(),
      'restaurantId': restaurantId,
    };
    return jsonEncode(data);
  }

  Future<void> joinOrder(String qrData) async {
    final decodedData = jsonDecode(qrData);
    // Join order logic
  }
}
```

## Installation Guide

### Prerequisites
- Flutter SDK (Latest stable version)
- Firebase CLI
- Node.js & npm
- Stripe Account
- Android Studio / VS Code

### Setup Steps

1. Clone the repository
```bash
git clone https://github.com/your-username/biteflow.git
cd biteflow
```

2. Install dependencies
```bash
flutter pub get
```

3. Configure Firebase
```bash
firebase init
# Configure Firebase services
firebase deploy
```

4. Configure Stripe
- Create a `.env` file:
```env
STRIPE_PUBLISHABLE_KEY=your_publishable_key
STRIPE_SECRET_KEY=your_secret_key
```

5. Run the application
```bash
flutter run
```

## Configuration

### Environment Variables
```yaml
# .env configuration
STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_SECRET_KEY=sk_test_...
FIREBASE_PROJECT_ID=your-project-id
FCM_SERVER_KEY=your-fcm-key
```

### Firebase Configuration
```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

### Stripe Configuration
```dart
Stripe.publishableKey = env['STRIPE_PUBLISHABLE_KEY']!;
await Stripe.instance.applySettings();
```

## Usage Guide

### Payment Processing
1. Create payment intent
2. Present payment sheet
3. Handle payment result
4. Update order status

### QR Code Sharing
1. Generate QR code for order
2. Share with other users
3. Scan and join order
4. Synchronize order details

## API Documentation

### Payment Endpoints
```dart
class PaymentAPI {
  static const String createIntent = '/create-payment-intent';
  static const String confirmPayment = '/confirm-payment';
  static const String refundPayment = '/refund-payment';
}
```

### Firebase Collections
```dart
class FirestoreCollections {
  static const String users = 'users';
  static const String orders = 'orders';
  static const String payments = 'payments';
  static const String restaurants = 'restaurants';
}
```

## Contributing

### Development Process
1. Fork the repository
2. Create feature branch
3. Implement changes
4. Submit pull request

### Code Standards
- Follow Flutter style guide
- Write unit tests
- Document new features
- Update README as needed

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE.md) file for details.

## Support

For support, email support@biteflow.com or join our Discord channel.

## Acknowledgments

- Dr. Milad Ghantous - Project Supervisor
- Team Members:
  - Abdelrahman Mohamed Salah
  - Ahmad Hoseiny AlShahhat
  - Mohamed Hassan Samy
  - Mohamed Khaled Fouad
  - Youssef Mohamed Shawky

---

© 2024 BiteFlow. All rights reserved.
