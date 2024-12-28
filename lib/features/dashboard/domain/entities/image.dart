enum ImageEventType {
  objectDetection,
  manualCapture,
}

class ImageRecord {
  final int id;
  final int expeditionId;
  final ImageEventType imageType;
  final String filePath;
  final bool objectDetected;
  final double? confidence;
  final String? objectClassName;
  final String createdAt;

  ImageRecord({
    required this.id,
    required this.expeditionId,
    required this.imageType,
    required this.filePath,
    required this.objectDetected,
    this.confidence,
    this.objectClassName,
    required this.createdAt,
  });
}
