import 'package:embedded_rov_v2/features/dashboard/data/models/image_model.dart';
import 'package:embedded_rov_v2/features/dashboard/domain/entities/expedition.dart';

class ExpeditionModel extends ExpeditionRecord {
  ExpeditionModel({
    required super.id,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    required super.imageList,
  });

  factory ExpeditionModel.fromJson(Map<String, dynamic> json) {
    return ExpeditionModel(
      id: json['id'] as int,
      status: stringToExpeditionStatus(json['status'] as String),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      imageList: json['image'] != null
          ? (json['image'] as List).map((e) => ImageModel.fromJson(e)).toList()
          : [],
    );
  }
}

ExpeditionStatus stringToExpeditionStatus(String status) {
  switch (status) {
    case 'completed':
      return ExpeditionStatus.completed;
    case 'active':
      return ExpeditionStatus.active;
    case 'error':
      return ExpeditionStatus.error;
    default:
      throw ArgumentError('Invalid status: $status');
  }
}
