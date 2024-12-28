import 'dart:async';

import 'package:embedded_rov_v2/core/common/dialog.dart';
import 'package:embedded_rov_v2/core/common/glassmorphism.dart';
import 'package:embedded_rov_v2/features/dashboard/presentation/bloc/expedition_bloc/expedition_bloc.dart';
import 'package:embedded_rov_v2/features/dashboard/presentation/pages/device_stream/page.dart';
import 'package:embedded_rov_v2/features/dashboard/presentation/pages/end_expedition_summary/page.dart';
import 'package:embedded_rov_v2/features/dashboard/presentation/widgets/AppBackground.dart';
import 'package:embedded_rov_v2/features/dashboard/presentation/widgets/DeviceInformationTile.dart';
import 'package:embedded_rov_v2/mqtt_service.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class DeviceSummary extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (builder) => const DeviceSummary());

  const DeviceSummary({super.key});

  @override
  State<DeviceSummary> createState() => _DeviceSummaryState();
}

class _DeviceSummaryState extends State<DeviceSummary> {
  late MqttService _mqttService;
  final TextEditingController _expeditionIdentifierController =
      TextEditingController();

  late StreamSubscription<int> _currentExpeditionStream;
  late Stream<bool> _expeditionStatusStream;
  late Stream<bool> _deviceStatusStream;
  late Stream<Map<String, String>> _deviceInfoStream;

  int _currentExpedition = 1;
  bool _expeditionIsActive = false;
  bool _deviceIsActive = false;
  late Map<String, String> _deviceInfo = {};

  @override
  void initState() {
    context
        .read<ExpeditionBloc>()
        .add(ExpeditionFetchSingleExpedition(expeditionId: 2));

    _mqttService = GetIt.I<MqttService>();
    _mqttService.connect();

    _currentExpeditionStream = _mqttService.currentExpedition.listen((exp) {
      if (mounted) {
        setState(() {
          _currentExpedition = exp;
        });
      }
    });

    _expeditionStatusStream = _mqttService.expeditionStatusStream;
    _expeditionStatusStream.listen((status) {
      setState(() {
        _expeditionIsActive = status;
      });
    });

    _deviceStatusStream = _mqttService.deviceStatusStream;
    _deviceStatusStream.listen((status) {
      setState(() {
        _deviceIsActive = status;
      });
    });

    _deviceInfoStream = _mqttService.deviceInfoStream;
    _deviceInfoStream.listen((info) {
      setState(() {
        _deviceInfo = info;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _expeditionIdentifierController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, constraints) {
        double deviceHeight = constraints.maxHeight;
        double deviceWidth = constraints.maxWidth;

        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            scrolledUnderElevation: 0,
            leadingWidth: 76,
            leading: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                splashFactory: NoSplash.splashFactory,
                foregroundColor: WidgetStatePropertyAll(
                  Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.75),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.75),
                  ),
                  color: Colors.blueGrey.withValues(alpha: 0.2),
                ),
                child: Icon(
                  FluentIcons.arrow_left_24_filled,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.75),
                  size: 24.0,
                ),
              ),
            ),
            actions: [
              _expeditionIsActive
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                      child: TextButton.icon(
                        onPressed: () {},
                        style: const ButtonStyle(
                          foregroundColor:
                              WidgetStatePropertyAll(Colors.redAccent),
                          splashFactory: NoSplash.splashFactory,
                        ),
                        label: const Text("End Expedition"),
                        icon: const Icon(FluentIcons.flag_off_24_regular),
                      ),
                    )
                  : const Spacer(),
            ],
          ),
          body: AppBackground(
            child: SizedBox(
              height: deviceHeight,
              width: deviceWidth,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        SizedBox(
                          height: deviceHeight * 0.5,
                          width: deviceWidth,
                          child: const ModelViewer(
                            backgroundColor: Colors.transparent,
                            src: 'assets/model/tinker.glb',
                            alt: 'A 3D model of an Underwater ROV',
                            autoRotate: true,
                            disableZoom: true,
                          ),
                        ),

                        /** Buttons **/
                        Positioned(
                          bottom: -30,
                          width: deviceWidth,
                          child: Column(
                            children: [
                              _mainButtonComponent(
                                context,
                                _expeditionIsActive,
                                _deviceIsActive,
                                _mqttService,
                                _deviceInfo,
                                _expeditionIdentifierController,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    /** Device Information Card **/

                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 56, 16, 24),
                      child: Column(
                        children: [
                          // Text(
                          //   _currentExpedition.toString(),
                          //   style: TextStyle(
                          //     fontSize: 24,
                          //   ),
                          // ),
                          Glassmorphism(
                            blur: 64,
                            opacity: 0.2,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  DeviceInformationTile(
                                    deviceInfo: _deviceInfo,
                                    deviceIsActive: _deviceIsActive,
                                    expeditionIsActive: _expeditionIsActive,
                                    isFirstContainer: true,
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          _deviceIsActive
                              ? Glassmorphism(
                                  blur: 64,
                                  opacity: 0.2,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        DeviceInformationTile(
                                          deviceInfo: _deviceInfo,
                                          deviceIsActive: _deviceIsActive,
                                          expeditionIsActive:
                                              _expeditionIsActive,
                                          isFirstContainer: false,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

ButtonStyle _mainButtonStyle(BuildContext context, bool isCircular,
    double paddingVertical, double paddingHorizontal, Color color) {
  return ButtonStyle(
    elevation: const WidgetStatePropertyAll(12),
    backgroundColor: WidgetStatePropertyAll(
      color, // Add translucency
    ),
    shadowColor: WidgetStatePropertyAll(Colors.black.withValues(alpha: 0.4)),
    padding: WidgetStatePropertyAll(
      EdgeInsets.symmetric(
          vertical: paddingVertical, horizontal: paddingHorizontal),
    ),
    shape: WidgetStatePropertyAll(
      isCircular
          ? CircleBorder(
              side: BorderSide(
                width: 1,
                color: Colors.white.withValues(alpha: 0.2),
              ),
            )
          : StadiumBorder(
              side: BorderSide(
                width: 1.3,
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
    ),
  );
}

Widget _mainButtonComponent(
  BuildContext context,
  bool expeditionActive,
  bool deviceisActive,
  MqttService mqttService,
  Map<String, String> deviceInfo,
  TextEditingController expeditionIdentifierController,
) {
  final formKey = GlobalKey<FormState>();

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EndExpeditionSummary()),
          );
        },
        style: _mainButtonStyle(
          context,
          true,
          24,
          24,
          Theme.of(context)
              .colorScheme
              .surfaceContainerHighest
              .withValues(alpha: 0.3),
        ),
        child: Center(
          child: Column(
            children: [
              Container(
                height: 16,
                width: 16,
                decoration: BoxDecoration(
                  color:
                      expeditionActive ? Colors.greenAccent : Colors.redAccent,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                expeditionActive ? "EM" : "SM",
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.75),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
      ElevatedButton(
        onPressed: () {
          if (expeditionActive) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (builder) => DeviceStream(
                  mqttService: mqttService,
                  deviceInfo: deviceInfo,
                ),
              ),
            );
            return;
          }

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return GeneralDialog(
                title: 'Add Expedition Identifier',
                description: 'Enter a unique expedition name',
                confirmButtonLabel: 'Continue',
                widget: Form(
                  key: formKey,
                  child: TextFormField(
                    controller: expeditionIdentifierController,
                    validator: (value) {
                      if (value!.isEmpty || value.length <= 8) {
                        return "Expedition name is invalid";
                      }
                      return null;
                    },
                  ),
                ),
                approvedFunction: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.pop(context);

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return GeneralDialog(
                          title:
                              'Start ${expeditionIdentifierController.text}?',
                          description:
                              'Do you want to start an expedition with this ROV?',
                          confirmButtonLabel: 'Start Expedition',
                          approvedFunction: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (builder) => DeviceStream(
                                  mqttService: mqttService,
                                  deviceInfo: deviceInfo,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                },
              );
            },
          );
        },
        style: _mainButtonStyle(
          context,
          false,
          10,
          32,
          Theme.of(context)
              .colorScheme
              .surfaceContainerHighest
              .withValues(alpha: 0.3),
        ),
        child: Column(
          children: [
            Text(
              "Underwater ROV Bot",
              style: TextStyle(
                fontFamily: "Satoshi",
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.025,
              ),
            ),
            Text(
              "Start expedition",
              style: TextStyle(
                fontFamily: "Satoshi",
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
      ),
      ElevatedButton(
        onPressed: () {},
        style: _mainButtonStyle(
            context,
            true,
            20,
            20,
            Theme.of(context)
                .colorScheme
                .surfaceContainerHighest
                .withValues(alpha: 0.3)),
        child: Center(
          child: Icon(
            FluentIcons.flash_24_regular,
            color: deviceisActive ? Colors.greenAccent : Colors.redAccent,
            size: 24,
          ),
        ),
      ),
    ],
  );
}
