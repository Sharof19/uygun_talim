import 'package:pr/features/payments/domain/entities/payment.dart';

abstract class PaymentRepository {
  Future<List<Payment>> getMyPayments();
  Future<List<Payment>> getSuccessPayments();
  Future<Map<String, dynamic>> getPaymentStatus(String paymentId);
  Future<Map<String, dynamic>> createPayment(Map<String, dynamic> payload);
}
