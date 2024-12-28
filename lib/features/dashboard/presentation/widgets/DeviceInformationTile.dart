import 'package:embedded_rov_v2/core/common/entities/device_info_model.dart';
import 'package:embedded_rov_v2/core/utils/device_info_utils.dart';
import 'package:embedded_rov_v2/core/utils/no_data_display.dart';
import 'package:flutter/material.dart';

class DeviceInformationTile extends StatefulWidget {
  final Map<String, String> deviceInfo;
  final bool expeditionIsActive;
  final bool isFirstContainer;
  final bool deviceIsActive;

  const DeviceInformationTile({
    super.key,
    required this.deviceInfo,
    required this.expeditionIsActive,
    required this.deviceIsActive,
    required this.isFirstContainer,
  });

  @override
  State<DeviceInformationTile> createState() => _DeviceInformationTileState();
}

class _DeviceInformationTileState extends State<DeviceInformationTile> {
  late DeviceInfoModel deviceInfo;
  late bool expeditionIsActive;
  late bool deviceIsActive;

  late bool isFirstContainer;

  @override
  void initState() {
    super.initState();
    expeditionIsActive = widget.expeditionIsActive;
    isFirstContainer = widget.isFirstContainer;
    deviceIsActive = widget.deviceIsActive;

    Map<String, String> testMap = widget.deviceInfo;

    //   {
    //     "Device Uptime": "6 h 15 min",
    //   "Device Board": "Raspberry Pi",
    //   "Operating System": "Raspbian OS",
    //   "CPU Usage": "32%",
    //   "CPU Temperature": "46°C",
    //   "Memory Usage": "64%",
    //   "Network Interface": "lan0",
    //   "Storage Usage": "24.1GB/120GB",
    // }

    testMap["Expedition Status"] =
        expeditionIsActive ? "On Expedition" : "Standby Mode";

    deviceInfo = DeviceInfoModel.fromJson(testMap);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    if (!deviceInfo.hasValues() || !deviceIsActive) {
      return NoDataDisplay(
        deviceWidth: deviceWidth,
        message: "No data to display\nDevice not active",
      );
    }

    final filteredEntries = deviceInfo.toJson().entries.where((entry) {
      if (isFirstContainer) {
        return !(entry.key.toLowerCase().contains('cpu') ||
            entry.key.toLowerCase().contains('memory') ||
            entry.key.toLowerCase().contains('storage'));
      } else {
        return !(entry.key.toLowerCase().contains('expedition') ||
            entry.key.toLowerCase().contains('device') ||
            entry.key.toLowerCase().contains('operating'));
      }
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /** Display mapped entries **/

        ...filteredEntries.map((entry) {
          final isLast =
              filteredEntries.indexOf(entry) == filteredEntries.length - 1;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.75),
                            fontSize: 16,
                            letterSpacing: 0.025,
                          ),
                        ),
                        Text(
                          entry.value,
                          style: TextStyle(
                            color: entry.key == "Expedition Status"
                                ? entry.value == "Standby Mode"
                                    ? Colors.orangeAccent
                                    : Colors.greenAccent
                                : Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    if (entry.key == "CPU Usage" ||
                        entry.key == "Memory Usage" ||
                        entry.key == "Storage Usage")
                      Column(
                        children: [
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(4),
                            value: calculateCpuUsage(
                              entry.key == "CPU Usage" ? entry.value : '50',
                            ),
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHigh,
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                  ],
                ),
              ),
              !isLast
                  ? Container(
                      height: 1,
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withOpacity(0.1),
                    )
                  : const SizedBox(height: 4),
            ],
          );
        }),
      ],
    );
  }
}
