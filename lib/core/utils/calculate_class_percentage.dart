import 'package:embedded_rov_v2/features/dashboard/domain/entities/image.dart';

List<Map<String, dynamic>> calculateClassPercentages(
    List<ImageRecord> imageList) {
  final totalImages = imageList.length;

  final objectDetectedList = imageList
      .where((image) => image.imageType == ImageEventType.objectDetection)
      .toList();

  final Map<String, int> classCounts = {};
  for (var image in objectDetectedList) {
    final className = image.objectClassName;
    if (className != null) {
      classCounts[className] = (classCounts[className] ?? 0) + 1;
    }
  }

  final formattedResult = classCounts.entries.map((entry) {
    final percentage =
        (entry.value / (totalImages > 0 ? totalImages : 1)) * 100;
    return {
      'percentage': '${percentage.toStringAsFixed(1)}%',
      'name': entry.key,
      'quantity': entry.value,
    };
  }).toList();

  return formattedResult;
}
