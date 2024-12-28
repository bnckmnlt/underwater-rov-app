part of 'expedition_bloc.dart';

@immutable
sealed class ExpeditionEvent {}

final class ExpeditionFetchAllExpedition extends ExpeditionEvent {}

final class ExpeditionFetchExpeditionImages extends ExpeditionEvent {
  final int expeditionId;

  ExpeditionFetchExpeditionImages({
    required this.expeditionId,
  });
}

final class ExpeditionFetchSingleExpedition extends ExpeditionEvent {
  final int expeditionId;

  ExpeditionFetchSingleExpedition({
    required this.expeditionId,
  });
}

final class ExpeditionStoreExpedition extends ExpeditionEvent {
  final String expeditionIdentifier;

  ExpeditionStoreExpedition(
    this.expeditionIdentifier,
  );
}
