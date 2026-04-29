class Profile {
  final String id;
  final String studentIdNumber;
  final String firstName;
  final String secondName;
  final String birthDate;
  final String gender;
  final String phoneNumber;
  const Profile({
    required this.id,
    required this.studentIdNumber,
    required this.firstName,
    required this.secondName,
    required this.birthDate,
    required this.gender,
    required this.phoneNumber,
  });
  String get fullName {
    final name = '\$firstName \$secondName'.trim();
    return name.isEmpty ? 'Foydalanuvchi' : name;
  }
}
