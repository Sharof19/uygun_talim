import 'package:pr/features/certificates/domain/entities/certificate.dart';
import 'package:pr/features/certificates/domain/repositories/certificate_repository.dart';

class GetMyCertificates {
  final CertificateRepository _r;
  GetMyCertificates(this._r);
  Future<List<Certificate>> call() => _r.getMyCertificates();
}
