import 'dart:async';

import 'package:embedded_rov_v2/core/common/entities/device_info_model.dart';
import 'package:embedded_rov_v2/features/dashboard/presentation/widgets/VideoFeedContainer.dart';
import 'package:embedded_rov_v2/mqtt_service.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toastification/toastification.dart';

class DeviceStream extends StatefulWidget {
  final MqttService mqttService;
  final Map<String, String> deviceInfo;

  const DeviceStream({
    super.key,
    required this.mqttService,
    required this.deviceInfo,
  });

  @override
  State<DeviceStream> createState() => _DeviceStreamState();
}

class _DeviceStreamState extends State<DeviceStream> {
  late DeviceInfoModel deviceInfo;
  late MqttService mqttService;

  late StreamSubscription<String> _controllerMovementSubscription;
  late StreamSubscription<Map<String, dynamic>> _rovEventSubscription;

  String _movement = "Stopped";

  @override
  void initState() {
    mqttService = widget.mqttService;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    Map<String, String> testMap = {
      "Device Uptime": "6 h 15 min",
      "Device Board": "Raspberry Pi",
      "Operating System": "Raspbian OS",
      "CPU Usage": "32%",
      "CPU Temperature": "46°C",
      "Memory Usage": "64%",
      "Network Interface": "lan0",
      "Storage Usage": "24.1GB/120GB",
    };

    deviceInfo = DeviceInfoModel.fromJson(testMap);

    _controllerMovementSubscription =
        mqttService.controllerMovementStream.where((movement) {
      return ["forward", "left", "right"].contains(movement);
    }).listen((movement) {
      if (mounted) {
        setState(() {
          _movement = movement;
        });
      }
    });

    _rovEventSubscription = mqttService.rovEventStream.listen((event) {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showToast(
            title: event["title"].toString(),
            description: event["response"].toString(),
            isError: event["event"] == "log" ? true : false,
          );
        });
      }
    });

    super.initState();
  }

  void showToast({
    required String title,
    required String description,
    required bool isError,
  }) {
    toastification.show(
      context: context,
      type: isError ? ToastificationType.error : ToastificationType.success,
      style: ToastificationStyle.flat,
      title: Text(title),
      description: Text(description),
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 4),
      animationBuilder: (
        context,
        animation,
        alignment,
        child,
      ) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
        width: 1,
      ),
      backgroundColor:
          Theme.of(context).colorScheme.surfaceContainer.withAlpha(248),
      borderRadius: BorderRadius.circular(4.0),
      showProgressBar: true,
      dragToClose: true,
    );
  }

  @override
  void dispose() {
    _controllerMovementSubscription.cancel();
    _rovEventSubscription.cancel();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(child: VideoFeedContainer()),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Text(
                      'Running',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Text(
                      'Object Detection',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 18.0, right: 32),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(FluentIcons.memory_16_regular,
                            color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          deviceInfo.cpuUsage,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.025,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Row(
                      children: [
                        Icon(FluentIcons.temperature_24_regular,
                            color: Colors.white),
                        const SizedBox(width: 2),
                        Text(
                          deviceInfo.cpuTemperature,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.025,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Row(
                      children: [
                        Icon(FluentIcons.data_area_24_regular,
                            color: Colors.white),
                        const SizedBox(width: 6),
                        Text(
                          deviceInfo.memoryUsage,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.025,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Row(
                      children: [
                        Icon(FluentIcons.clock_24_regular, color: Colors.white),
                        const SizedBox(width: 6),
                        Text(
                          deviceInfo.deviceUptime,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.025,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0, left: 16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withValues(alpha: 0.3),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _movement == "left"
                            ? FluentIcons.chevron_left_24_regular
                            : _movement == "right"
                                ? FluentIcons.chevron_right_20_regular
                                : FluentIcons.chevron_up_24_regular,
                        color: Colors.tealAccent.shade200,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Turning $_movement",
                        style: TextStyle(
                          color: Colors.grey.withValues(alpha: 0.75),
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          letterSpacing: 0.025,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
