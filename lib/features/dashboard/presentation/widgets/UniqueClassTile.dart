import 'package:embedded_rov_v2/features/dashboard/domain/entities/image.dart';
import 'package:flutter/material.dart';

class UniqueClassTile extends StatelessWidget {
  final BuildContext context;
  final double deviceWidth;
  final List<ImageRecord> objectDetectedList;
  final List<Map<String, dynamic>> uniqueClass;

  const UniqueClassTile({
    super.key,
    required this.context,
    required this.deviceWidth,
    required this.objectDetectedList,
    required this.uniqueClass,
  });

  @override
  Widget build(BuildContext context) {
    if (uniqueClass.isEmpty) {
      return Container(
        height: 64,
        child: Center(
          child: Text(
            "No data available",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Column(
      children: uniqueClass.map((data) {
        final percentage = data['percentage'] ?? '0%';
        final name = data['name'] ?? 'Unknown';
        final quantity = data['quantity'] ?? 0;

        final progressValue = (quantity /
            (objectDetectedList.length > 0 ? objectDetectedList.length : 1));

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                percentage,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: deviceWidth * 0.20,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: deviceWidth * 0.25,
                child: LinearProgressIndicator(
                  value: progressValue,
                  minHeight: 6.0,
                  backgroundColor: Theme.of(context).colorScheme.surfaceDim,
                  borderRadius: BorderRadius.circular(4),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              // Quantity Text
              Container(
                width: deviceWidth * 0.15,
                child: Text(
                  "$quantity item/s",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
