import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:nazi_shop/backend/api_client.dart';

class StripeService {
  static const String _publishableKey = String.fromEnvironment(
    'STRIPE_PUBLISHABLE_KEY',
    defaultValue:
        'pk_test_51QP6E5Rt3wD0c5G6bWvA2yQ1lZ4fX9jH8kL3mN7oP9qR2sT5uV8xY0zW1aB4cD7eF2gH5iJ8kL0mN3oP6q', // Replace with real key or keep env var
  );

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    // Set publishable key
    // In production, this should come from environment variables or a secure configuration
    Stripe.publishableKey = _publishableKey;

    if (!kIsWeb) {
      await Stripe.instance.applySettings();
    }
    _initialized = true;
  }

  static Future<bool> processPayment({
    required String orderId,
    required BuildContext context,
  }) async {
    try {
      // 1. Get payment intent from backend
      // We assume order is already created and we just need the payment intent
      final response = await ApiClient.post(
        '/payments/create-intent',
        body: {'orderId': orderId},
      );

      final clientSecret = response['clientSecret'];
      if (clientSecret == null) {
        throw Exception('Failed to get client secret');
      }

      // 2. Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: 'Nazi Shop',
          paymentIntentClientSecret: clientSecret,
          style: ThemeMode.system,
          appearance: PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          // Apple Pay / Google Pay configuration could be added here
        ),
      );

      // 3. Present payment sheet
      await Stripe.instance.presentPaymentSheet();

      // 4. If we are here, payment was successful
      return true;
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        // User cancelled, do nothing (or show minor message)
        return false;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de pago: ${e.error.localizedMessage}')),
      );
      return false;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      return false;
    }
  }
}
