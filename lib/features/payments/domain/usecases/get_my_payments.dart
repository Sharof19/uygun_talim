import 'package:pr/features/payments/domain/entities/payment.dart';
import 'package:pr/features/payments/domain/repositories/payment_repository.dart';

class GetMyPayments {
  final PaymentRepository _r;
  GetMyPayments(this._r);
  Future<List<Payment>> call() => _r.getMyPayments();
}
