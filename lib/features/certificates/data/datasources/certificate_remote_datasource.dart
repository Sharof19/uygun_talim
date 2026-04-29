import 'package:pr/core/network/api_client.dart';
import 'package:pr/features/certificates/data/models/certificate_model.dart';

abstract class CertificateRemoteDataSource {
  Future<List<CertificateModel>> getMyCertificates(String token);
  Future<List<CertificateModel>> getAllCertificates(String token);
  Future<Map<String, dynamic>> getCertificateDetail(String token, String id);
}

class CertificateRemoteDataSourceImpl implements CertificateRemoteDataSource {
  final ApiClient _client;
  CertificateRemoteDataSourceImpl(this._client);
  @override
  Future<List<CertificateModel>> getMyCertificates(String token) async {
    final list = await _client.getList(
      '\${ApiConstants.certificates}/my/',
      token: token,
    );
    return list.map(CertificateModel.fromMap).toList();
  }

  @override
  Future<List<CertificateModel>> getAllCertificates(String token) async {
    final list = await _client.getList(
      '\${ApiConstants.certificates}/',
      token: token,
    );
    return list.map(CertificateModel.fromMap).toList();
  }

  @override
  Future<Map<String, dynamic>> getCertificateDetail(String token, String id) =>
      _client.getMap('\${ApiConstants.certificates}/\$id/', token: token);
}
