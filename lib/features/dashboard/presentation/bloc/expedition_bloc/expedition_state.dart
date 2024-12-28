part of 'expedition_bloc.dart';

@immutable
sealed class ExpeditionState {
  const ExpeditionState();
}

final class ExpeditionInitial extends ExpeditionState {}

final class ExpeditionLoading extends ExpeditionState {}

final class ExpeditionDisplaySuccess extends ExpeditionState {
  final List<ExpeditionRecord> expeditions;

  const ExpeditionDisplaySuccess(this.expeditions);
}

final class ExpeditionImagesSuccess extends ExpeditionState {
  final List<ImageRecord> images;

  const ExpeditionImagesSuccess(this.images);
}

final class ExpeditionRecordSuccess extends ExpeditionState {
  final ExpeditionRecord expedition;

  const ExpeditionRecordSuccess(this.expedition);
}

final class ExpeditionStoreSuccess extends ExpeditionState {
  final String message;

  const ExpeditionStoreSuccess(this.message);
}

final class ExpeditionFailure extends ExpeditionState {
  final String error;

  const ExpeditionFailure(this.error);
}
