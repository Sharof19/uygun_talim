import 'package:pr/features/certificates/domain/entities/certificate.dart';

abstract class CertificateRepository {
  Future<List<Certificate>> getMyCertificates();
  Future<List<Certificate>> getAllCertificates();
  Future<Map<String, dynamic>> getCertificateDetail(String id);
}
