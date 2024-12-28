import 'package:easy_stepper/easy_stepper.dart';
import 'package:embedded_rov_v2/features/dashboard/domain/entities/expedition.dart';
import 'package:flutter/material.dart';

class StatusStepperWidget extends StatefulWidget {
  final ExpeditionStatus expeditionStatus;

  const StatusStepperWidget({
    super.key,
    required this.expeditionStatus,
  });

  @override
  State<StatusStepperWidget> createState() => _StatusStepperWidgetState();
}

class _StatusStepperWidgetState extends State<StatusStepperWidget> {
  late int activeStep = 0;

  @override
  Widget build(BuildContext context) {
    final expeditionStatus = widget.expeditionStatus.toString();

    switch (expeditionStatus) {
      case 'ExpeditionStatus.completed':
        setState(() {
          activeStep = 2;
        });
        break;
      case 'ExpeditionStatus.active':
        setState(() {
          activeStep = 1;
        });
        break;
      case 'ExpeditionStatus.error':
        setState(() {
          activeStep = 0;
        });
        break;
      default:
        setState(() {
          activeStep = 0;
        });
        break;
    }

    return EasyStepper(
      activeStep: activeStep,
      activeStepTextColor: Colors.lightBlueAccent,
      activeStepBackgroundColor:
          Theme.of(context).colorScheme.surfaceContainerHighest,
      finishedStepTextColor: Colors.blueGrey.shade700,
      finishedStepBackgroundColor:
          Theme.of(context).colorScheme.surfaceContainer,
      internalPadding: 32,
      showLoadingAnimation: false,
      stepRadius: 18,
      showStepBorder: false,
      fitWidth: true,
      steps: [
        EasyStep(
          customStep: CircleAvatar(
            radius: 8,
            backgroundColor: Theme.of(context).colorScheme.surfaceDim,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: activeStep >= 0
                  ? Colors.lightBlueAccent
                  : Theme.of(context).colorScheme.surfaceDim,
            ),
          ),
          title: 'Initial',
          topTitle: false,
        ),
        EasyStep(
          customStep: CircleAvatar(
            radius: 8,
            backgroundColor: Theme.of(context).colorScheme.surfaceDim,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: activeStep >= 1
                  ? Colors.lightBlueAccent
                  : Theme.of(context).colorScheme.surfaceDim,
            ),
          ),
          title: 'Active',
          topTitle: false,
        ),
        EasyStep(
          customStep: CircleAvatar(
            radius: 8,
            backgroundColor: Theme.of(context).colorScheme.surfaceDim,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: activeStep >= 2
                  ? Colors.lightBlueAccent
                  : Theme.of(context).colorScheme.surfaceDim,
            ),
          ),
          title: 'Completed',
          topTitle: false,
        ),
      ],
      onStepReached: (index) {
        setState(() => activeStep = index);
      },
    );
  }
}
