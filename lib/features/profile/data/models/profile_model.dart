import 'package:pr/features/profile/domain/entities/profile.dart';

class ProfileModel extends Profile {
  const ProfileModel({
    required super.id,
    required super.studentIdNumber,
    required super.firstName,
    required super.secondName,
    required super.birthDate,
    required super.gender,
    required super.phoneNumber,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> d) {
    String gender = '';
    final raw = d['gender'];

    if (raw is Map<String, dynamic>) {
      gender = (raw['name'] as String?) ?? '';
    } else if (raw != null) {
      final match = RegExp(
        r'''name["']?\s*:\s*["']([^"']+)''',
      ).firstMatch(raw.toString());
      gender = match?.group(1) ?? raw.toString();
    }

    return ProfileModel(
      id: (d['id'] ?? '').toString(),
      studentIdNumber: (d['student_id_number'] ?? '').toString(),
      firstName: (d['first_name'] ?? '').toString(),
      secondName: (d['second_name'] ?? '').toString(),
      birthDate: (d['birth_date'] ?? '').toString(),
      gender: gender,
      phoneNumber: (d['phone_number'] ?? '').toString(),
    );
  }
}
