import 'package:embedded_rov_v2/core/common/glassmorphism.dart';
import 'package:embedded_rov_v2/features/dashboard/presentation/pages/device_summary/page.dart';
import 'package:embedded_rov_v2/features/dashboard/presentation/widgets/AppBackground.dart';
import 'package:embedded_rov_v2/mqtt_service.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({super.key});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  late MqttService _mqttService;

  late Stream<bool> _expeditionStatusStream;
  late Stream<bool> _deviceStatusStream;

  bool _expeditionActive = false;
  bool _deviceisActive = false;

  @override
  void initState() {
    super.initState();

    _mqttService = GetIt.I<MqttService>();
    _mqttService.connect();

    _expeditionStatusStream = _mqttService.expeditionStatusStream;
    _deviceStatusStream = _mqttService.deviceStatusStream;

    _expeditionStatusStream.listen((status) {
      setState(() {
        _expeditionActive = status;
      });
    });

    _deviceStatusStream.listen((status) {
      setState(() {
        _deviceisActive = status;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double deviceHeight = constraints.maxHeight;
        double deviceWidth = constraints.maxWidth;

        return Scaffold(
          extendBody: true,
          appBar: AppBar(
            elevation: 0,
            toolbarHeight: 86,
            scrolledUnderElevation: 0,
            backgroundColor: Colors.transparent,
            title: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Robot Management\n",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontFamily: "Satoshi",
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: "Manage the currently available ROV/s",
                    style: TextStyle(
                      fontFamily: "Satoshi",
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.5),
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: AppBackground(
            child: Container(
              height: deviceHeight,
              width: deviceWidth,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Glassmorphism(
                    blur: 20,
                    opacity: 0.2,
                    child: Container(
                      width: deviceWidth * 0.30,
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              "assets/images/underwater-rov-general.jpg",
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Underwater ROV",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.025,
                            ),
                          ),
                          Text(
                            "1 Robot/s",
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.75),
                              letterSpacing: 0.025,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  /** Robots Summary **/
                  const Text(
                    "Robots Available",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.025,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DeviceSummary(),
                        ),
                      );
                    },
                    child: Glassmorphism(
                      blur: 20,
                      opacity: 0.2,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 24, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.asset(
                                    "assets/images/underwater-rov.jpg",
                                    height: 76.0,
                                    width: 76.0,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Underwater ROV",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.025,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          FluentIcons.circle_24_filled,
                                          size: 8,
                                          color: _deviceisActive
                                              ? Colors.greenAccent
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          _deviceisActive
                                              ? "Active"
                                              : "Not active",
                                          style: TextStyle(
                                            color: _deviceisActive
                                                ? Colors.greenAccent
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .error,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.025,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Align(
                              alignment:
                                  Alignment.centerRight, // Align the content
                              child: Column(
                                children: [
                                  Container(
                                    height: 16,
                                    width: 16,
                                    decoration: BoxDecoration(
                                      color: _expeditionActive
                                          ? Colors.greenAccent
                                          : Theme.of(context).colorScheme.error,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    _expeditionActive ? "E" : "F",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.75),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
