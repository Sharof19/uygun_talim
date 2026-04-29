import 'package:pr/core/network/api_client.dart';
import 'package:pr/features/payments/data/models/payment_model.dart';

abstract class PaymentRemoteDataSource {
  Future<List<PaymentModel>> getMyPayments(String token);
  Future<List<PaymentModel>> getSuccessPayments(String token);
  Future<Map<String, dynamic>> getPaymentStatus(String token, String id);
  Future<Map<String, dynamic>> createPayment(
    String token,
    Map<String, dynamic> payload,
  );
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final ApiClient _client;
  PaymentRemoteDataSourceImpl(this._client);
  @override
  Future<List<PaymentModel>> getMyPayments(String token) async {
    final list = await _client.getList(
      '\${ApiConstants.payments}/my/',
      token: token,
    );
    return list.map(PaymentModel.fromMap).toList();
  }

  @override
  Future<List<PaymentModel>> getSuccessPayments(String token) async {
    final list = await _client.getList(
      '\${ApiConstants.payments}/success/',
      token: token,
    );
    return list.map(PaymentModel.fromMap).toList();
  }

  @override
  Future<Map<String, dynamic>> getPaymentStatus(String token, String id) =>
      _client.getMap('\${ApiConstants.payments}/\$id/status/', token: token);
  @override
  Future<Map<String, dynamic>> createPayment(
    String token,
    Map<String, dynamic> payload,
  ) => _client.post(
    '\${ApiConstants.payments}/create/',
    token: token,
    body: payload,
  );
}
