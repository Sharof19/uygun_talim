import 'package:pr/features/profile/domain/entities/profile.dart';
import 'package:pr/features/profile/domain/repositories/profile_repository.dart';

class GetProfile {
  final ProfileRepository _r;
  GetProfile(this._r);
  Future<Profile> call() => _r.getProfile();
}
