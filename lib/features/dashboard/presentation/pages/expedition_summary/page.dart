import 'package:card_slider/card_slider.dart';
import 'package:embedded_rov_v2/core/utils/calculate_class_percentage.dart';
import 'package:embedded_rov_v2/core/utils/error_display.dart';
import 'package:embedded_rov_v2/core/utils/no_data_display.dart';
import 'package:embedded_rov_v2/features/dashboard/data/models/image_model.dart';
import 'package:embedded_rov_v2/features/dashboard/domain/entities/image.dart';
import 'package:embedded_rov_v2/features/dashboard/presentation/bloc/expedition_bloc/expedition_bloc.dart';
import 'package:embedded_rov_v2/features/dashboard/presentation/widgets/AppBackground.dart';
import 'package:embedded_rov_v2/features/dashboard/presentation/widgets/GallerySection.dart';
import 'package:embedded_rov_v2/features/dashboard/presentation/widgets/StatusStepperWidget.dart';
import 'package:embedded_rov_v2/features/dashboard/presentation/widgets/UniqueClassTile.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExpeditionSummary extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (builder) => const ExpeditionSummary(
          expeditionId: null,
        ),
      );

  final int? expeditionId;

  const ExpeditionSummary({
    super.key,
    required this.expeditionId,
  });

  @override
  State<ExpeditionSummary> createState() => _ExpeditionSummaryState();
}

class _ExpeditionSummaryState extends State<ExpeditionSummary> {
  late SupabaseClient _supabaseClient;

  late List<Widget> imageWidgets = [];

  @override
  void initState() {
    super.initState();
    _supabaseClient = Supabase.instance.client;

    context.read<ExpeditionBloc>().add(
          ExpeditionFetchSingleExpedition(
            expeditionId: widget.expeditionId as int,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        final navigator = Navigator.of(context);

        context.read<ExpeditionBloc>().add(ExpeditionFetchAllExpedition());

        navigator.pop(result);
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
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
                  context
                      .read<ExpeditionBloc>()
                      .add(ExpeditionFetchAllExpedition());
                },
                style: ButtonStyle(
                  splashFactory: NoSplash.splashFactory,
                  foregroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.75),
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
                          .withOpacity(0.3),
                    ),
                    color: Colors.blueGrey.withOpacity(0.2),
                  ),
                  child: const Icon(
                    FluentIcons.arrow_left_24_filled,
                    size: 24.0,
                  ),
                ),
              ),
            ),
            body: AppBackground(
              child: BlocBuilder<ExpeditionBloc, ExpeditionState>(
                builder: (context, state) {
                  if (state is ExpeditionLoading) {
                    return SizedBox(
                        height: deviceHeight * 0.5,
                        child: Center(
                            child: LoadingAnimationWidget.discreteCircle(
                          color: Colors.blueAccent,
                          size: 38,
                        )));
                  }

                  if (state is ExpeditionRecordSuccess) {
                    final manualCapturedList = state.expedition.imageList
                        .where((image) =>
                            image.imageType == ImageEventType.manualCapture)
                        .map((image) {
                      final imageModel = image as ImageModel;
                      final formattedPath =
                          image.filePath.toString().replaceFirst("images/", "");
                      final publicUrl = _supabaseClient.storage
                          .from('images')
                          .getPublicUrl(formattedPath);
                      return imageModel.copyWith(filePath: publicUrl);
                    }).toList();

                    final objectDetectedList = state.expedition.imageList
                        .where((image) =>
                            image.imageType == ImageEventType.objectDetection)
                        .map((image) {
                      final imageModel = image as ImageModel;
                      final formattedPath =
                          image.filePath.toString().replaceFirst("images/", "");
                      final publicUrl = _supabaseClient.storage
                          .from('images')
                          .getPublicUrl(formattedPath);
                      return imageModel.copyWith(filePath: publicUrl);
                    }).toList();

                    final uniqueClasses = objectDetectedList
                        .map((image) => image.objectClassName)
                        .toSet()
                        .length;

                    final uniqueClassesList =
                        calculateClassPercentages(objectDetectedList);

                    final urls = state.expedition.imageList.map((image) {
                      final formattedPath =
                          image.filePath.toString().replaceFirst("images/", "");
                      return _supabaseClient.storage
                          .from('images')
                          .getPublicUrl(formattedPath);
                    }).toList();

                    final imageWidgets = urls
                        .map((url) => ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: Image.network(
                                url,
                                fit: BoxFit.cover,
                                height: 244,
                              ),
                            ))
                        .toList();

                    final items = [
                      {'label': 'Market Cap', 'value': '\$5.90B'},
                      {'label': 'Volume', 'value': '\$1.23M'},
                    ];

                    return Container(
                      height: deviceHeight,
                      width: deviceWidth,
                      padding: const EdgeInsets.fromLTRB(0, 38, 0, 24),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text.rich(
                                textAlign: TextAlign.center,
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "ID: ${state.expedition.id}\n",
                                      style: TextStyle(
                                        fontFamily: "Satoshi",
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.025,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "Manila Expedition",
                                      style: const TextStyle(
                                        fontFamily: "Satoshi",
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: deviceWidth,
                              child: StatusStepperWidget(
                                expeditionStatus: state.expedition.status,
                              ),
                            ),
                            (imageWidgets.isNotEmpty)
                                ? CardSlider(
                                    cards: imageWidgets,
                                  )
                                : NoDataDisplay(
                                    deviceWidth: deviceWidth,
                                    message: "No images available"),
                            const SizedBox(height: 44),

                            /** Device stats summary **/
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 16.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: MediaQuery.of(context)
                                              .platformBrightness ==
                                          Brightness.dark
                                      ? Theme.of(context)
                                          .colorScheme
                                          .surfaceContainerLow
                                          .withOpacity(0.5)
                                      : Theme.of(context)
                                          .colorScheme
                                          .surfaceContainer
                                          .withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: List.generate(
                                    items.length * 2 - 1,
                                    (index) {
                                      if (index.isEven) {
                                        final item = items[index ~/ 2];
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                item['label']!,
                                                style: TextStyle(
                                                  letterSpacing: 0.025,
                                                ),
                                              ),
                                              Text(
                                                item['value']!,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return Container(
                                          height: 1,
                                          width: double.infinity,
                                          color: MediaQuery.of(context)
                                                      .platformBrightness ==
                                                  Brightness.dark
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .surfaceContainer
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .outline
                                                  .withOpacity(0.3),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            /** Expedition Summary **/
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: MediaQuery.of(context)
                                              .platformBrightness ==
                                          Brightness.dark
                                      ? Theme.of(context)
                                          .colorScheme
                                          .surfaceContainerLow
                                          .withOpacity(0.5)
                                      : Theme.of(context)
                                          .colorScheme
                                          .surfaceContainer
                                          .withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding:
                                    const EdgeInsets.fromLTRB(16, 20, 16, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Expedition Summary",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.025,
                                      ),
                                    ),

                                    // Summary
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 20.0, 0, 20.0),
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            WidgetSpan(
                                              alignment:
                                                  PlaceholderAlignment.middle,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors
                                                      .lightBlueAccent.shade100
                                                      .withOpacity(0.2),
                                                  border: Border.all(
                                                    color: Colors
                                                        .lightBlueAccent
                                                        .shade100,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          6.0),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 2.0,
                                                  horizontal: 2.0,
                                                ),
                                                margin: const EdgeInsets.only(
                                                  right: 6.0,
                                                ),
                                                child: Icon(
                                                  FluentIcons.flash_24_filled,
                                                  color: Colors
                                                      .lightBlueAccent.shade700,
                                                  size: 14,
                                                ),
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  "Today you had 20% more meetings than usual, you closed 2 tasks on two projects, but the focus was 12% lower than yesterday.",
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                                fontFamily: "Satoshi",
                                                height: 1.4,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 1,
                                      width: double.infinity,
                                      color: MediaQuery.of(context)
                                                  .platformBrightness ==
                                              Brightness.dark
                                          ? Theme.of(context)
                                              .colorScheme
                                              .surfaceContainer
                                          : Theme.of(context)
                                              .colorScheme
                                              .outline
                                              .withOpacity(0.3),
                                    ),

                                    // Uptime Stats
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 20.0, 0, 28.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Device uptime",
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface
                                                      .withOpacity(0.75),
                                                ),
                                              ),
                                              const SizedBox(height: 2.0),
                                              const Text(
                                                "6 hr 18 min",
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.025,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "Max Pressure Reached",
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface
                                                      .withOpacity(0.75),
                                                ),
                                              ),
                                              const SizedBox(height: 2.0),
                                              const Text(
                                                "6 hr 18 min",
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.025,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),

                                    // Images
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                            color: MediaQuery.of(context)
                                                        .platformBrightness ==
                                                    Brightness.dark
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .surfaceContainer
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .outline
                                                    .withOpacity(0.3),
                                          ),
                                          bottom: BorderSide(
                                            color: MediaQuery.of(context)
                                                        .platformBrightness ==
                                                    Brightness.dark
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .surfaceContainer
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .outline
                                                    .withOpacity(0.3),
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          _buildStatisticContainer(
                                            state.expedition.imageList.length
                                                .toString(),
                                            "Total\nImages",
                                          ),
                                          _buildDivider(context),
                                          _buildStatisticContainer(
                                            manualCapturedList.length
                                                .toString(),
                                            "Manual\nCapture",
                                          ),
                                          _buildDivider(context),
                                          _buildStatisticContainer(
                                            objectDetectedList.length
                                                .toString(),
                                            "Object\nDetected",
                                          ),
                                          _buildDivider(context),
                                          _buildStatisticContainer(
                                            uniqueClasses.toString(),
                                            "Unique\nObjects",
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Classname
                                    Container(
                                      width: deviceWidth,
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 20, 0, 28),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Object detections acquired",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withOpacity(0.75),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          UniqueClassTile(
                                            context: context,
                                            deviceWidth: deviceWidth,
                                            objectDetectedList:
                                                objectDetectedList,
                                            uniqueClass: uniqueClassesList,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),

                            /** Image Gallery **/
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: Container(
                                width: deviceWidth,
                                decoration: BoxDecoration(
                                  color: MediaQuery.of(context)
                                              .platformBrightness ==
                                          Brightness.dark
                                      ? Theme.of(context)
                                          .colorScheme
                                          .surfaceContainerLow
                                          .withOpacity(0.5)
                                      : Theme.of(context)
                                          .colorScheme
                                          .surfaceContainer
                                          .withOpacity(0.5)
                                          .withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding:
                                    const EdgeInsets.fromLTRB(16, 20, 16, 4),
                                child: Column(
                                  children: [
                                    GallerySection(
                                      title: "Manual Capture",
                                      itemList: manualCapturedList,
                                      titleGallery: "Manual Captures",
                                      deviceWidth: deviceWidth,
                                    ),
                                    GallerySection(
                                      title: "Objects Detected",
                                      itemList: objectDetectedList,
                                      titleGallery: "Objects Detected",
                                      deviceWidth: deviceWidth,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  if (state is ExpeditionFailure) {
                    return ErrorDisplay(
                        errorMessage:
                            "Failed to load logs\nError: ${state.error.toString()}");
                  }

                  return SizedBox(
                    height: deviceWidth,
                    child: NoDataDisplay(
                        deviceWidth: deviceWidth,
                        message: "Something went wrong"),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget _buildDivider(BuildContext context) {
  return SizedBox(
    height: 124,
    child: VerticalDivider(
      width: 1,
      thickness: 1,
      color: MediaQuery.of(context).platformBrightness == Brightness.dark
          ? Theme.of(context).colorScheme.surfaceContainer
          : Theme.of(context).colorScheme.outline.withOpacity(0.3),
    ),
  );
}

Widget _buildStatisticContainer(String number, String label) {
  const EdgeInsets containerPadding = EdgeInsets.fromLTRB(0, 14, 0, 24);

  const TextStyle numberTextStyle = TextStyle(
    fontSize: 38,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.025,
  );

  const TextStyle labelTextStyle = TextStyle(
    height: 1.2,
    letterSpacing: 0.025,
  );

  return Container(
    padding: containerPadding,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          number,
          style: numberTextStyle,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: labelTextStyle,
        ),
      ],
    ),
  );
}
