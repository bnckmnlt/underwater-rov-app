import 'package:embedded_rov_v2/features/dashboard/domain/entities/image.dart';

class ImageModel extends ImageRecord {
  ImageModel({
    required super.id,
    required super.expeditionId,
    required super.imageType,
    required super.filePath,
    required super.objectDetected,
    super.confidence,
    super.objectClassName,
    required super.createdAt,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'] as int,
      expeditionId: json['expedition_id'] as int,
      imageType: stringToImageEventType(json['image_type'] as String),
      filePath: json['file_path'] as String,
      objectDetected: json['object_detected'] as bool,
      confidence: json['confidence'] != null
          ? (json['confidence'] as num).toDouble()
          : null,
      objectClassName: json['object_classname'] as String?,
      createdAt: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'expeditionId': expeditionId,
      'imageType': imageType.index,
      'filePath': filePath,
      'objectDetected': objectDetected,
      'confidence': confidence,
      'objectClassName': objectClassName,
      'createdAt': createdAt,
    };
  }

  ImageRecord copyWith({
    int? id,
    int? expeditionId,
    ImageEventType? imageType,
    String? filePath,
    bool? objectDetected,
    double? confidence,
    String? objectClassName,
    String? createdAt,
  }) {
    return ImageRecord(
      id: id ?? this.id,
      expeditionId: expeditionId ?? this.expeditionId,
      imageType: imageType ?? this.imageType,
      filePath: filePath ?? this.filePath,
      objectDetected: objectDetected ?? this.objectDetected,
      confidence: confidence ?? this.confidence,
      objectClassName: objectClassName ?? this.objectClassName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

ImageEventType stringToImageEventType(String eventType) {
  switch (eventType) {
    case 'object_detection':
      return ImageEventType.objectDetection;
    case 'manual_capture':
      return ImageEventType.manualCapture;
    default:
      throw ArgumentError('Invalid eventType: $eventType');
  }
}
