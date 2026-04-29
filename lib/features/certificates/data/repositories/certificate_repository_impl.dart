import 'package:pr/core/errors/exceptions.dart';
import 'package:pr/core/storage/secure_storage.dart';
import 'package:pr/features/certificates/data/datasources/certificate_remote_datasource.dart';
import 'package:pr/features/certificates/domain/entities/certificate.dart';
import 'package:pr/features/certificates/domain/repositories/certificate_repository.dart';

class CertificateRepositoryImpl implements CertificateRepository {
  final CertificateRemoteDataSource _remote;
  final SecureStorage _storage;
  CertificateRepositoryImpl(this._remote, this._storage);
  Future<String> _token() async {
    final t = await _storage.readAccessToken();
    if (t == null || t.isEmpty) {
      throw const AuthException('Access token topilmadi.');
    }
    return t;
  }

  @override
  Future<List<Certificate>> getMyCertificates() async =>
      _remote.getMyCertificates(await _token());
  @override
  Future<List<Certificate>> getAllCertificates() async =>
      _remote.getAllCertificates(await _token());
  @override
  Future<Map<String, dynamic>> getCertificateDetail(String id) async =>
      _remote.getCertificateDetail(await _token(), id);
}
