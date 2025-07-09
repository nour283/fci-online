import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:tadrib_hub/presentation/Screens/Layout/pages/language_provider.dart';

class PaymentPage extends StatefulWidget {
  final String courseId;
  final String token;

  const PaymentPage({
    Key? key,
    required this.courseId,
    required this.token,
  }) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool isLoading = false;

  void showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> startPayment() async {
    setState(() => isLoading = true);

    try {
      final clientSecret = await createPaymentIntent(
        token: widget.token,
        courseId: widget.courseId,
      );

      if (clientSecret == null || !clientSecret.contains('secret')) {
        throw Exception("Invalid client secret received");
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Tadrib Hub',
          style: ThemeMode.system,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      showMessage("🎉 Payment completed successfully!");
      if (mounted) Navigator.of(context).pop(true);
    } on StripeException catch (e) {
      debugPrint('❌ Stripe error: ${e.error.localizedMessage}');
      showMessage('Payment failed: ${e.error.localizedMessage}', isError: true);
    } catch (e) {
      debugPrint('❌ Unexpected error: $e');
      String errorMessage = e.toString();

      if (errorMessage.contains('already enrolled')) {
        showMessage('You are already enrolled in this course!', isError: false);
        if (mounted) Navigator.of(context).pop(true);
      } else {
        showMessage(errorMessage, isError: true);
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<String?> createPaymentIntent({
    required String token,
    required String courseId,
  }) async {
    final uri = Uri.parse('https://elearnbackend-production.up.railway.app/api/payments/flutter-checkout');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({'courseId': courseId});

    try {
      final response = await http
          .post(uri, headers: headers, body: body)
          .timeout(const Duration(seconds: 20));

      final data = jsonDecode(response.body);
      debugPrint('🔄 PaymentIntent Response: ${response.body}');

      if (response.statusCode == 200 && data['success'] == true) {
        return data['clientSecret'];
      } else {
        final errorMessage = data['message'] ?? 'Something went wrong';

        if (errorMessage == 'You are already enrolled in this course') {
          throw Exception('already enrolled');
        } else {
          throw Exception(errorMessage);
        }
      }
    } catch (e) {
      debugPrint('❌ createPaymentIntent failed: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Provider.of<LanguageProvider>(context).isArabic;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: Text(isArabic ? 'دفع الكورس' : 'Course Payment'),
        backgroundColor: const Color(0xFF49BBBD),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.lock_outline_rounded, size: 80, color: Color(0xFF49BBBD)),
                      const SizedBox(height: 20),
                      Text(
                        isArabic ? "دفع آمن" : "Secure Checkout",
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        isArabic
                            ? "أكمل الدفع للوصول إلى محتوى الكورس بالكامل."
                            : "Complete your payment to access all course content instantly.",
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: isLoading
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                              : const Icon(Icons.credit_card),
                          label: Text(
                            isLoading
                                ? (isArabic ? "جاري المعالجة..." : "Processing...")
                                : (isArabic ? "ادفع الآن" : "Pay Now"),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          onPressed: isLoading ? null : startPayment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF49BBBD),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
