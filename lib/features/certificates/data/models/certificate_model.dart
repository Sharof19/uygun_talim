import 'package:pr/features/certificates/domain/entities/certificate.dart';

class CertificateModel extends Certificate {
  const CertificateModel({
    required super.id,
    required super.title,
    required super.issuedAt,
    required super.fileUrl,
  });
  factory CertificateModel.fromMap(Map<String, dynamic> d) => CertificateModel(
    id: (d['id'] ?? '').toString(),
    title: (d['title'] ?? d['name'] ?? d['course_title'] ?? '').toString(),
    issuedAt: (d['issued_at'] ?? d['created_at'] ?? d['date'] ?? '').toString(),
    fileUrl: (d['file'] ?? d['file_url'] ?? d['url'] ?? '').toString(),
  );
}
