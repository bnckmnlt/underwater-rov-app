import 'package:embedded_rov_v2/features/dashboard/domain/entities/image.dart';

enum ExpeditionStatus { active, completed, error }

class ExpeditionRecord {
  final int id;
  final ExpeditionStatus status;
  final String expeditionIdentifier;
  final String deviceUptime;
  final String maxPressure;
  final String createdAt;
  final String updatedAt;
  final List<ImageRecord> imageList;

  ExpeditionRecord({
    required this.id,
    required this.status,
    required this.expeditionIdentifier,
    required this.deviceUptime,
    required this.maxPressure,
    required this.createdAt,
    required this.updatedAt,
    required this.imageList,
  });
}
