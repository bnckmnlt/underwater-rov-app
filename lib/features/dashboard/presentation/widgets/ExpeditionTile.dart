import 'package:embedded_rov_v2/features/dashboard/domain/entities/expedition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_randomcolor/flutter_randomcolor.dart';
import 'package:intl/intl.dart';

class ExpeditionTile extends StatefulWidget {
  final int expeditionId;
  final ExpeditionStatus status;
  final String createdAt;
  final String updatedAt;

  const ExpeditionTile({
    super.key,
    required this.expeditionId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  State<ExpeditionTile> createState() => _ExpeditionTileState();
}

class _ExpeditionTileState extends State<ExpeditionTile> {
  @override
  void initState() {
    super.initState();
  }

  String formatDate(String date, String pattern) {
    return DateFormat(pattern).format(DateTime.parse(date));
  }

  @override
  Widget build(BuildContext context) {
    final Color color = RandomColor.getColorObject(Options(
      colorType: ColorType.blue,
      luminosity: MediaQuery.of(context).platformBrightness == Brightness.dark
          ? Luminosity.dark
          : Luminosity.light,
    ));

    double deviceWidth = MediaQuery.of(context).size.width;

    String formattedCreatedDate = formatDate(widget.createdAt, 'yyyy\nMMM dd');
    String formattedCreatedTime = formatDate(widget.createdAt, 'HH:mm');
    String formattedUpdatedDate = formatDate(widget.createdAt, 'yyyy\nMMM dd');
    String formattedUpdatedTime = formatDate(widget.createdAt, 'HH:mm');

    return ClipPath(
      clipper: CardClipper(),
      child: Card(
        elevation: 0.13,
        child: Container(
          width: deviceWidth,
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          child: Column(
            children: [
              // Row with status chips
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ID Chip
                  Chip(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    side: const BorderSide(color: Colors.transparent),
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    label: Text(
                      "ID:${widget.expeditionId}",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontFamily: "Geist Mono",
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.025,
                        height: 0,
                      ),
                    ),
                  ),
                  // Status Chip
                  expeditionStatusChip(widget.status)
                ],
              ),
              const SizedBox(height: 10),
              // Title Text
              const Align(
                child: Text(
                  "Manila Expedition",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.025,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_searching_outlined,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(formattedCreatedTime),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "${formattedCreatedDate.split('\n')[0]}\n",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.025,
                                height: 1.2,
                              ),
                            ),
                            TextSpan(
                              text: formattedCreatedDate.split('\n')[1],
                              style: const TextStyle(
                                fontWeight: FontWeight.w300,
                                letterSpacing: 0.025,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Center Text: Uptime
                  Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: "Uptime\n",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.025,
                          ),
                        ),
                        const TextSpan(
                          text: "16h 15m",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.025,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Right Column: End Date and Time
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(formattedCreatedTime),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "${formattedUpdatedTime.split('\n')[0]}\n",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.025,
                                height: 1.2,
                              ),
                            ),
                            TextSpan(
                              text: formattedUpdatedDate.split('\n')[1],
                              style: const TextStyle(
                                fontWeight: FontWeight.w300,
                                letterSpacing: 0.025,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CardClipper extends CustomClipper<Path> {
  static const double topOffset = 0;
  static const double firstPointX = 0.35;
  static const double notchWidth = 0.3;
  static const double notchDepth = 0.13;

  @override
  Path getClip(Size size) {
    return _buildClipPath(size);
  }

  Path _buildClipPath(Size size) {
    final Path clipPath = Path();
    clipPath.moveTo(0, size.height * topOffset);
    clipPath.lineTo(size.width * firstPointX, 0);

    clipPath.lineTo(
      size.width * (firstPointX + notchWidth * 0.25),
      size.height * notchDepth,
    );

    clipPath.lineTo(
      size.width * (firstPointX + notchWidth * 0.75),
      size.height * notchDepth,
    );

    clipPath.lineTo(
      size.width * (firstPointX + notchWidth),
      0,
    );

    clipPath.lineTo(size.width, size.height * topOffset);
    clipPath.lineTo(size.width, size.height);
    clipPath.lineTo(0, size.height);
    clipPath.close();

    return clipPath;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

Widget expeditionStatusChip(ExpeditionStatus status) {
  String label;
  Color backgroundColor;
  Color foregroundColor;

  switch (status) {
    case ExpeditionStatus.completed:
      label = "Completed";
      backgroundColor = Colors.greenAccent.shade200;
      foregroundColor = Colors.greenAccent.shade700;
      break;
    case ExpeditionStatus.active:
      label = "Active";
      backgroundColor = Colors.orange.shade200;
      foregroundColor = Colors.orange.shade700;
      break;
    case ExpeditionStatus.error:
      label = "Error";
      backgroundColor = Colors.red.shade200;
      foregroundColor = Colors.red.shade700;
      break;
  }

  return Chip(
    backgroundColor: backgroundColor.withOpacity(0.3),
    side: BorderSide(color: backgroundColor),
    label: Text(
      label,
      style: TextStyle(
        color: foregroundColor,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
