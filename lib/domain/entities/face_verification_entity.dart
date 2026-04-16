import 'package:equatable/equatable.dart';
class FaceVerificationEntity extends Equatable {
  final String id;
  final String userId;
  final bool isVerified;
  final double confidence;
  final String? faceImagePath;
  final DateTime verifiedAt;
  final String? failureReason;

  const FaceVerificationEntity({
    required this.id,
    required this.userId,
    required this.isVerified,
    required this.confidence,
    this.faceImagePath,
    required this.verifiedAt,
    this.failureReason,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    isVerified,
    confidence,
    faceImagePath,
    verifiedAt,
    failureReason,
  ];
}