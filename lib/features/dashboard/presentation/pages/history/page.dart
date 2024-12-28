import 'package:embedded_rov_v2/core/utils/error_display.dart';
import 'package:embedded_rov_v2/features/dashboard/presentation/bloc/expedition_bloc/expedition_bloc.dart';
import 'package:embedded_rov_v2/features/dashboard/presentation/pages/expedition_summary/page.dart';
import 'package:embedded_rov_v2/features/dashboard/presentation/widgets/AppBackground.dart';
import 'package:embedded_rov_v2/features/dashboard/presentation/widgets/ExpeditionTile.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    context.read<ExpeditionBloc>().add(ExpeditionFetchAllExpedition());

    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceHeight = constraints.maxHeight;
        final deviceWidth = constraints.maxWidth;

        return Scaffold(
          body: AppBackground(
            child: Container(
              height: deviceHeight,
              width: deviceWidth,
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 64),
                    SearchBar(
                      controller: _searchController,
                      padding: const WidgetStatePropertyAll<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      leading: const Icon(
                        FluentIcons.search_24_regular,
                      ),
                      trailing: _searchController.text.isNotEmpty
                          ? <Widget>[
                              IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                },
                                icon:
                                    const Icon(FluentIcons.dismiss_24_regular),
                              ),
                            ]
                          : [],
                    ),
                    const SizedBox(height: 16.0),
                    const Row(
                      children: [
                        Spacer(),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        const Text(
                          "Your Expeditions",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.025,
                          ),
                        ),
                        const SizedBox(width: 8),
                        BlocBuilder<ExpeditionBloc, ExpeditionState>(
                          builder: (context, state) {
                            int expeditionCount = 0;
                            if (state is ExpeditionDisplaySuccess) {
                              expeditionCount = state.expeditions.length;
                            }

                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6.0, horizontal: 12.0),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerLow,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "$expeditionCount",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<ExpeditionBloc, ExpeditionState>(
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

                        if (state is ExpeditionDisplaySuccess) {
                          final expedition = state.expeditions;

                          return Column(
                            children: expedition
                                .map(
                                  (expedition) => GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ExpeditionSummary(
                                                  expeditionId: expedition.id),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: ExpeditionTile(
                                        expeditionId: expedition.id,
                                        status: expedition.status,
                                        identifier:
                                            expedition.expeditionIdentifier,
                                        createdAt: expedition.createdAt,
                                        updatedAt: expedition.updatedAt,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          );
                        }

                        if (state is ExpeditionFailure) {
                          return ErrorDisplay(
                              errorMessage:
                                  "Failed to load logs\nError: ${state.error.toString()}");
                        }

                        return const SizedBox();
                      },
                    ),
                    const SizedBox(height: 86),
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
