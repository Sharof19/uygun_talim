import 'package:dartz/dartz.dart';
import 'package:pr/core/error/failures.dart';
import 'package:pr/core/usecase/usecase.dart';
import 'package:pr/domain/entities/face_verification_entity.dart';
import 'package:pr/domain/repositories/face_verification_repository.dart';
class VerifyFaceUseCase extends UseCase<FaceVerificationEntity, VerifyFaceParams> {
  final FaceVerificationRepository repository;
  VerifyFaceUseCase(this.repository);
  @override
  Future<Either<Failure, FaceVerificationEntity>> call(VerifyFaceParams params) {
    return repository.verifyFace(params.userId, params.imagePath);
  }
}
class VerifyFaceParams {
  final String userId;
  final String imagePath;
  VerifyFaceParams({required this.userId, required this.imagePath,});
}