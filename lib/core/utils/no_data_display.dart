import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class NoDataDisplay extends StatelessWidget {
  final double deviceWidth;
  final String message;

  const NoDataDisplay({
    super.key,
    required this.deviceWidth,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Center(
      child: Container(
        height: height * 0.15,
        width: deviceWidth,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                FluentIcons.error_circle_24_regular,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                size: 38,
              ),
              const SizedBox(height: 6),
              Text(
                message,
                style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
