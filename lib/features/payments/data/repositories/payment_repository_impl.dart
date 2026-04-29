import 'package:pr/core/errors/exceptions.dart';
import 'package:pr/core/storage/secure_storage.dart';
import 'package:pr/features/payments/data/datasources/payment_remote_datasource.dart';
import 'package:pr/features/payments/domain/entities/payment.dart';
import 'package:pr/features/payments/domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource _remote;
  final SecureStorage _storage;
  PaymentRepositoryImpl(this._remote, this._storage);
  Future<String> _token() async {
    final t = await _storage.readAccessToken();
    if (t == null || t.isEmpty) {
      throw const AuthException('Access token topilmadi.');
    }
    return t;
  }

  @override
  Future<List<Payment>> getMyPayments() async =>
      _remote.getMyPayments(await _token());
  @override
  Future<List<Payment>> getSuccessPayments() async =>
      _remote.getSuccessPayments(await _token());
  @override
  Future<Map<String, dynamic>> getPaymentStatus(String id) async =>
      _remote.getPaymentStatus(await _token(), id);
  @override
  Future<Map<String, dynamic>> createPayment(
    Map<String, dynamic> payload,
  ) async => _remote.createPayment(await _token(), payload);
}
