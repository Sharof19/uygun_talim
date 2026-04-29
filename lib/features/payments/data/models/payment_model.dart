import 'package:pr/features/payments/domain/entities/payment.dart';

class PaymentModel extends Payment {
  const PaymentModel({
    required super.id,
    required super.amount,
    required super.currency,
    required super.status,
    required super.createdAt,
  });
  factory PaymentModel.fromMap(Map<String, dynamic> d) => PaymentModel(
    id: (d['id'] ?? '').toString(),
    amount: (d['amount'] ?? d['price'] ?? d['sum'] ?? '').toString(),
    currency: (d['currency'] ?? d['currency_code'] ?? '').toString(),
    status: (d['status'] ?? d['state'] ?? '').toString(),
    createdAt: (d['created_at'] ?? d['date'] ?? '').toString(),
  );
}
