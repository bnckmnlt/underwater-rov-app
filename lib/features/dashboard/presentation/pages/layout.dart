import 'package:embedded_rov_v2/features/dashboard/presentation/pages/device/page.dart';
import 'package:embedded_rov_v2/features/dashboard/presentation/pages/history/page.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

enum Pages { device, history }

class LayoutPage extends StatefulWidget {
  const LayoutPage({super.key});

  @override
  State<LayoutPage> createState() => _LayoutState();
}

class _LayoutState extends State<LayoutPage> {
  final List<Widget> pages = [
    const DevicePage(),
    const HistoryPage(),
  ];

  Pages currentPage = Pages.device;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double deviceHeight = constraints.maxHeight;
        double deviceWidth = constraints.maxWidth;

        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          body: SizedBox(
            height: deviceHeight,
            width: deviceWidth,
            child: Stack(
              children: [
                pages[currentPage == Pages.device ? 0 : 1],
                Positioned(
                  bottom: 24,
                  left: (deviceWidth - 300) / 2,
                  child: SizedBox(
                    width: 300,
                    child: SegmentedButton<Pages>(
                      style: ButtonStyle(
                        splashFactory: NoSplash.splashFactory,
                        padding: const WidgetStatePropertyAll(
                          EdgeInsets.symmetric(vertical: 20.0),
                        ),
                        shape: WidgetStatePropertyAll<OutlinedBorder>(
                            RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        )),
                      ),
                      showSelectedIcon: false,
                      segments: [
                        ButtonSegment<Pages>(
                          value: Pages.device,
                          label: const Text(''),
                          icon: Icon(
                            FluentIcons.bot_24_filled,
                            size: 28,
                            color: currentPage == Pages.device
                                ? Colors.lightBlueAccent
                                : Theme.of(context)
                                    .colorScheme
                                    .outline
                                    .withValues(alpha: 1),
                          ),
                        ),
                        ButtonSegment<Pages>(
                          value: Pages.history,
                          label: Text(''),
                          icon: Icon(
                            FluentIcons.map_24_filled,
                            size: 28,
                            color: currentPage == Pages.history
                                ? Colors.lightBlueAccent
                                : Theme.of(context)
                                    .colorScheme
                                    .outline
                                    .withValues(alpha: 1),
                          ),
                        ),
                      ],
                      selected: {currentPage},
                      onSelectionChanged: (Set<Pages> newSelection) {
                        setState(() {
                          currentPage = newSelection.first;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
