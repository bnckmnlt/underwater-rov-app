import 'package:embedded_rov_v2/core/common/animation.dart';
import 'package:embedded_rov_v2/core/common/glassmorphism.dart';
import 'package:embedded_rov_v2/core/utils/error_display.dart';
import 'package:embedded_rov_v2/core/utils/no_data_display.dart';
import 'package:embedded_rov_v2/features/dashboard/data/models/image_model.dart';
import 'package:embedded_rov_v2/features/dashboard/domain/entities/expedition.dart';
import 'package:embedded_rov_v2/features/dashboard/domain/entities/image.dart';
import 'package:embedded_rov_v2/features/dashboard/presentation/bloc/expedition_bloc/expedition_bloc.dart';
import 'package:embedded_rov_v2/features/dashboard/presentation/widgets/AppBackground.dart';
import 'package:embedded_rov_v2/features/dashboard/presentation/widgets/GallerySection.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EndExpeditionSummary extends StatefulWidget {
  const EndExpeditionSummary({super.key});

  @override
  State<EndExpeditionSummary> createState() => _EndExpeditionSummaryState();
}

class _EndExpeditionSummaryState extends State<EndExpeditionSummary>
    with TickerProviderStateMixin {
  late SupabaseClient _supabaseClient;
  late AnimationController _controller;

  double initialDelay = 1.75;

  @override
  void initState() {
    _supabaseClient = Supabase.instance.client;

    context.read<ExpeditionBloc>().add(
          ExpeditionFetchSingleExpedition(
            expeditionId: 7,
          ),
        );

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        scrolledUnderElevation: 0,
        leadingWidth: 76,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            foregroundColor: WidgetStatePropertyAll(
              theme.colorScheme.onSurface.withValues(alpha: 0.75),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.75),
              ),
              color: Colors.blueGrey.withValues(alpha: 0.2),
            ),
            child: Icon(
              FluentIcons.arrow_left_24_filled,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
              size: 24.0,
            ),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final deviceHeight = constraints.maxHeight;
          final deviceWidth = constraints.maxWidth;

          return SizedBox(
            height: deviceHeight,
            width: deviceWidth,
            child: BlocBuilder<ExpeditionBloc, ExpeditionState>(
              builder: (context, state) {
                if (state is ExpeditionLoading) {
                  return SizedBox(
                      height: deviceHeight,
                      child: Center(
                          child: LoadingAnimationWidget.discreteCircle(
                        color: Colors.blueAccent,
                        size: 38,
                      )));
                }

                if (state is ExpeditionRecordSuccess) {
                  final List<Map<String, dynamic>> informationList =
                      _maptoList(state.expedition, _supabaseClient);

                  return AppBackground(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 86, 20, 24),
                        child: Column(
                          children: [
                            /** Container pulse **/
                            Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  ScaleTransition(
                                    scale: Tween<double>(begin: 0.7, end: 0.85)
                                        .animate(CurvedAnimation(
                                      parent: _controller,
                                      curve: Curves.easeOut,
                                    )),
                                    child: Container(
                                      height: deviceHeight * 0.18,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.greenAccent.shade100
                                            .withValues(alpha: 0.1),
                                      ),
                                    ),
                                  ),
                                  Lottie.asset(
                                    'assets/animations/success-animate.json',
                                    repeat: false,
                                    height: deviceHeight * 0.25,
                                  ),
                                ],
                              ),
                            ),

                            /** Text Section **/
                            SizedBox(
                              width: deviceWidth * 0.80,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  BounceWithFadeAnimation(
                                    delay: 1,
                                    child: Text(
                                      "${state.expedition.expeditionIdentifier} has ended successfully",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.025,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6.0),
                                  BounceWithFadeAnimation(
                                    delay: 1.25,
                                    child: Text(
                                      "The current expedition with the ROV has been successfully concluded.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.75),
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /** Summary Section **/
                            const SizedBox(height: 32.0),
                            BounceWithFadeAnimation(
                              delay: 1.5,
                              child: Glassmorphism(
                                blur: 24,
                                opacity: 0.15,
                                child: Container(
                                  width: deviceWidth,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 24.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: theme.colorScheme.outline
                                          .withValues(alpha: 0.5),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Expedition Summary",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.025,
                                        ),
                                      ),

                                      /** Stats **/
                                      const SizedBox(height: 24.0),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ...informationList.where((entry) {
                                            return entry['label'] !=
                                                "Public Image URLs";
                                          }).map((entry) {
                                            final widget =
                                                BounceWithFadeAnimation(
                                              delay: initialDelay,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 0, 20),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      entry['label'],
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurface
                                                            .withAlpha(191),
                                                        fontSize: 16,
                                                        letterSpacing: 0.025,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    Text(
                                                      entry['value'].toString(),
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurface,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                            initialDelay += 0.15;
                                            return widget;
                                          }).toList(),

                                          /** Container Footer **/
                                          BounceWithFadeAnimation(
                                            delay: initialDelay,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 18, 0, 0),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  top: BorderSide(
                                                    color: theme
                                                        .colorScheme.onSurface
                                                        .withValues(alpha: 0.1),
                                                  ),
                                                ),
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    "Expedition Status",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 4.0,
                                                        horizontal: 16.0),
                                                    decoration: BoxDecoration(
                                                      color: Colors
                                                          .greenAccent.shade400
                                                          .withValues(
                                                              alpha: 0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              24.0),
                                                    ),
                                                    child: const Row(
                                                      children: [
                                                        Icon(
                                                          FluentIcons
                                                              .checkmark_24_filled,
                                                          size: 18,
                                                          color: Colors
                                                              .greenAccent,
                                                        ),
                                                        SizedBox(width: 4.0),
                                                        Text(
                                                          "Completed",
                                                          style: TextStyle(
                                                            color: Colors
                                                                .greenAccent,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
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
                              ),
                            ),

                            /** Footer **/
                            const SizedBox(height: 32.0),
                            BounceWithFadeAnimation(
                              delay: initialDelay + 0.15,
                              child: Container(
                                width: deviceWidth * 0.86,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 20),
                                    child: GallerySection(
                                        title: "All Images",
                                        itemList: informationList.last['value'],
                                        titleGallery: "All Images",
                                        deviceWidth: deviceWidth),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                if (state is ExpeditionFailure) {
                  return ErrorDisplay(
                      errorMessage:
                          "Failed to load information\nError: ${state.error.toString()}");
                }

                return SizedBox(
                  height: deviceWidth,
                  child: NoDataDisplay(
                      deviceWidth: deviceWidth,
                      message: "Something went wrong"),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

List<Map<String, dynamic>> _maptoList(
    ExpeditionRecord expedition, SupabaseClient supabase) {
  final f = DateFormat("dd MMM yyyy, hh:mm");

  final createdAt = DateTime.parse(expedition.createdAt);
  final updatedAt = DateTime.parse(expedition.updatedAt);

  final duration = updatedAt.difference(createdAt);
  final hours = duration.inHours;
  final minutes = duration.inMinutes % 60;

  return [
    {
      'label': 'Expedition ID',
      'value': "EXP-0${expedition.id}",
    },
    {
      'label': 'Created At',
      'value': f.format(createdAt),
    },
    {
      'label': 'Updated At',
      'value': f.format(updatedAt),
    },
    {
      'label': 'Expedition Duration',
      'value': "${hours}h ${minutes}min",
    },
    {
      'label': 'Total Images',
      'value': "${expedition.imageList.length} image/s",
    },
    {
      'label': 'Object Detections',
      'value':
          "${expedition.imageList.where((image) => image.imageType == ImageEventType.objectDetection).length} item/s",
    },
    {
      'label': 'Manual Captures',
      'value':
          "${expedition.imageList.where((image) => image.imageType == ImageEventType.manualCapture).length} item/s",
    },
    {
      'label': 'Unique Object Classes',
      'value':
          "${expedition.imageList.where((image) => image.imageType == ImageEventType.objectDetection).map((image) => image.objectClassName).toSet().length} classes",
    },
    {
      'label': 'Uptime',
      'value': "6h 15 min",
    },
    {
      'label': 'Public Image URLs',
      'value': expedition.imageList.map((image) {
        final imageModel = image as ImageModel;
        final formattedPath =
            image.filePath.toString().replaceFirst("images/", "");
        final publicUrl =
            supabase.storage.from('images').getPublicUrl(formattedPath);
        return imageModel.copyWith(filePath: publicUrl);
      }).toList(),
    },
  ];
}
