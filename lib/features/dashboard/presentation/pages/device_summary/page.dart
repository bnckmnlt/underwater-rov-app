import 'dart:async';
import 'dart:convert';

import 'package:embedded_rov_v2/core/common/dialog.dart';
import 'package:embedded_rov_v2/core/common/glassmorphism.dart';
import 'package:embedded_rov_v2/core/utils/no_data_display.dart';
import 'package:embedded_rov_v2/features/dashboard/domain/entities/expedition.dart';
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
import 'package:intl/intl.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:toastification/toastification.dart';

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

  late int _currentExpedition;
  bool _expeditionIsActive = false;
  bool _deviceIsActive = false;
  late Map<String, String> _deviceInfo = {};

  @override
  void initState() {
    super.initState();

    _mqttService = GetIt.I<MqttService>();
    _mqttService.connect();

    setState(() {
      _currentExpedition = 1;
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

    _currentExpeditionStream = _mqttService.currentExpedition.listen((exp) {
      if (mounted) {
        setState(() {
          _currentExpedition = exp;

          context.read<ExpeditionBloc>().add(
                ExpeditionFetchSingleExpedition(
                    expeditionId: _currentExpedition),
              );
        });
      }
    });

    _currentExpeditionStream.onDone(() {
      _currentExpeditionStream.cancel();
    });

    _deviceInfoStream = _mqttService.deviceInfoStream;
    _deviceInfoStream.listen((info) {
      setState(() {
        _deviceInfo = info;
      });
    });
  }

  Future<void> _refreshConnectionStatus() async {
    showToast(
      title: "Device Reconnecting",
      description: "Device is reconnecting to the system",
      isError: false,
      isInformation: true,
      duration: 2,
    );

    await Future.delayed(const Duration(milliseconds: 2500));

    _mqttService.disconnect();
    _mqttService.connect();

    if (_deviceIsActive) {
      showToast(
        title: "Device is now active",
        description: "Device is now active and ready for expedition",
        isError: false,
      );
    } else {
      showToast(
        title: "Something went wrong",
        description:
            "Device is currently inactive, check the connection within the board",
        isError: true,
      );
    }
  }

  void showToast({
    required String title,
    required String description,
    required bool isError,
    final bool isInformation = false,
    final int duration = 4,
  }) {
    toastification.show(
      context: context,
      type: isError
          ? ToastificationType.error
          : isInformation
              ? ToastificationType.info
              : ToastificationType.success,
      style: ToastificationStyle.flat,
      title: Text(title),
      description: Text(description),
      alignment: Alignment.topRight,
      autoCloseDuration: Duration(seconds: duration),
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
                  ? BlocConsumer<ExpeditionBloc, ExpeditionState>(
                      listener: (context, state) {
                        if (state is ExpeditionFailure) {
                          toastification.show(
                            context: context,
                            type: ToastificationType.error,
                            style: ToastificationStyle.flat,
                            title: Text("Something went wrong"),
                            description: Text(state.error),
                            alignment: Alignment.topRight,
                            autoCloseDuration: Duration(seconds: 4),
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
                              color: Theme.of(context)
                                  .colorScheme
                                  .outline
                                  .withValues(alpha: 0.5),
                              width: 1,
                            ),
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .surfaceContainer
                                .withAlpha(248),
                            borderRadius: BorderRadius.circular(4.0),
                            showProgressBar: true,
                            dragToClose: true,
                          );
                        } else if (state is ExpeditionEndSuccess) {
                          Navigator.pop(context);

                          _mqttService.publish(
                            "rov/expedition/status",
                            jsonEncode({"isActive": false}),
                            qos: MqttQos.exactlyOnce,
                            retain: true,
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EndExpeditionSummary(
                                expeditionId: _currentExpedition,
                              ),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                          child: TextButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return GeneralDialog(
                                    title: 'Close Expedition',
                                    description:
                                        'Would you like to finalize the current expedition?',
                                    confirmButtonLabel: 'Close Expedition',
                                    approvedFunction: () {
                                      context.read<ExpeditionBloc>().add(
                                            ExpeditionEndExpedition(
                                              _currentExpedition,
                                            ),
                                          );
                                    },
                                  );
                                },
                              );
                            },
                            style: const ButtonStyle(
                              foregroundColor:
                                  WidgetStatePropertyAll(Colors.redAccent),
                              splashFactory: NoSplash.splashFactory,
                            ),
                            label: const Text("End Expedition"),
                            icon: const Icon(
                              FluentIcons.flag_off_24_regular,
                              color: Colors.redAccent,
                            ),
                          ),
                        );
                      },
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
                                _currentExpedition,
                                _refreshConnectionStatus,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    /** Device Information Card **/
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 64, 16, 56),
                      child: Column(
                        children: [
                          BlocBuilder<ExpeditionBloc, ExpeditionState>(
                            builder: (context, state) {
                              if (state is ExpeditionRecordSuccess) {
                                final formattedDateTime = DateFormat(
                                        "${state.expedition.status == ExpeditionStatus.completed ? "'E'n'd'e'd'" : "'S't'a'r't'e'd'"} on dd MMM yyyy, hh:mm a")
                                    .format(DateTime.parse(
                                        state.expedition.status ==
                                                ExpeditionStatus.completed
                                            ? state.expedition.updatedAt
                                            : state.expedition.createdAt));

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          state.expedition.expeditionIdentifier,
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.025,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              14, 2, 14, 2),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(14.0),
                                            border: Border.all(
                                              width: 0.75,
                                              color: state.expedition.status ==
                                                      ExpeditionStatus.active
                                                  ? Colors.orangeAccent.shade100
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                            ),
                                          ),
                                          child: Text(
                                            state.expedition.status ==
                                                    ExpeditionStatus.active
                                                ? "Active"
                                                : "Completed",
                                            style: TextStyle(
                                              color: state.expedition.status ==
                                                      ExpeditionStatus.active
                                                  ? Colors.orangeAccent
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "EXP-00${state.expedition.id}",
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(
                                                  alpha: 0.8,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Icon(
                                          FluentIcons.circle_24_filled,
                                          size: 6,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withValues(
                                                alpha: 0.8,
                                              ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          formattedDateTime,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(
                                                  alpha: 0.8,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }

                              return SizedBox(
                                height: deviceWidth * 0.25,
                                child: NoDataDisplay(
                                    deviceWidth: deviceWidth,
                                    message:
                                        "No expedition data to display\n No records yet"),
                              );
                            },
                          ),

                          /** Board Information **/
                          const SizedBox(height: 24),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Board Information",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.025,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Glassmorphism(
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
                                        expeditionIsActive: _expeditionIsActive,
                                        isFirstContainer: true,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          /** Board Performance **/
                          const SizedBox(height: 24),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "System Performance",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.025,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Glassmorphism(
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
                                        expeditionIsActive: _expeditionIsActive,
                                        isFirstContainer: false,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
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
      color,
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
  int expeditionId,
  Function() _refreshConnectionStatus,
) {
  final formKey = GlobalKey<FormState>();

  return BlocConsumer<ExpeditionBloc, ExpeditionState>(
    listener: (context, state) {
      if (state is ExpeditionFailure) {
        toastification.show(
          context: context,
          type: ToastificationType.error,
          style: ToastificationStyle.flat,
          title: Text("Something went wrong"),
          description: Text(state.error),
          alignment: Alignment.topRight,
          autoCloseDuration: Duration(seconds: 4),
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
      } else if (state is ExpeditionStoreSuccess) {
        toastification.show(
          context: context,
          type: ToastificationType.error,
          style: ToastificationStyle.flat,
          title: Text("${state.message} has started"),
          description: Text("Expedition has started successfully"),
          alignment: Alignment.topRight,
          autoCloseDuration: Duration(seconds: 4),
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

        mqttService.publish(
          "rov/expedition/status",
          jsonEncode({"isActive": true}),
          qos: MqttQos.exactlyOnce,
          retain: true,
        );

        mqttService.publish(
          "rov/expedition",
          (expeditionId + 1).toString(),
          qos: MqttQos.exactlyOnce,
          retain: true,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (builder) => DeviceStream(
              mqttService: mqttService,
              deviceInfo: deviceInfo,
            ),
          ),
        );
      }
    },
    builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Tooltip(
                message: !deviceisActive
                    ? 'Device is currently inactive'
                    : 'Ready for expedition',
                child: ElevatedButton(
                  onPressed: !deviceisActive
                      ? null
                      : () {
                          if (expeditionActive && deviceisActive) {
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
                          } else {
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
                                      controller:
                                          expeditionIdentifierController,
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            value.length <= 8) {
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
                                            confirmButtonLabel:
                                                'Start Expedition',
                                            approvedFunction: () {
                                              Navigator.pop(context);

                                              context
                                                  .read<ExpeditionBloc>()
                                                  .add(
                                                    ExpeditionStoreExpedition(
                                                      expeditionIdentifierController
                                                          .text
                                                          .trim(),
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
                          }
                        },
                  style: _mainButtonStyle(
                    context,
                    false,
                    10,
                    32,
                    !deviceisActive
                        ? Colors.blueGrey.shade100.withAlpha(16)
                        : Colors.blue.withAlpha(32),
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
                        deviceisActive
                            ? expeditionActive
                                ? "Continue your expedition"
                                : "Start expedition"
                            : "Device not available",
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
              ),
            ),
            const SizedBox(width: 12),
            Tooltip(
              message: 'Board Status',
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return GeneralDialog(
                        title: 'Connection Status',
                        withTitle: false,
                        isDismissable: true,
                        description:
                            'These are the connection statuses of the system:',
                        confirmButtonLabel: 'Refresh',
                        approvedFunction: _refreshConnectionStatus,
                        widget: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Device Status',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.75),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    deviceisActive ? 'Active' : 'Inactive',
                                    style: TextStyle(
                                      color: deviceisActive
                                          ? Colors.greenAccent
                                          : Colors.redAccent,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Expedition Status',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.75),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    expeditionActive ? 'Active' : 'Inactive',
                                    style: TextStyle(
                                      color: expeditionActive
                                          ? Colors.greenAccent
                                          : Colors.redAccent,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                style: _mainButtonStyle(
                  context,
                  true,
                  24,
                  24,
                  !deviceisActive || !expeditionActive
                      ? Colors.blueGrey.shade100.withAlpha(16)
                      : Colors.blue.withAlpha(32),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(
                          color: expeditionActive
                              ? Colors.greenAccent
                              : Colors.redAccent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        expeditionActive ? "EM" : "SM",
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.5),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
