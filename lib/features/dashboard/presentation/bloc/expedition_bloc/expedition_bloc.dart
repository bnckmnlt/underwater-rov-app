import 'package:embedded_rov_v2/core/usecase/usecase.dart';
import 'package:embedded_rov_v2/features/dashboard/domain/entities/expedition.dart';
import 'package:embedded_rov_v2/features/dashboard/domain/entities/image.dart';
import 'package:embedded_rov_v2/features/dashboard/domain/usecases/end_expedition.dart';
import 'package:embedded_rov_v2/features/dashboard/domain/usecases/fetch_all_expedition.dart';
import 'package:embedded_rov_v2/features/dashboard/domain/usecases/fetch_expedition_images.dart';
import 'package:embedded_rov_v2/features/dashboard/domain/usecases/fetch_single_expedition.dart';
import 'package:embedded_rov_v2/features/dashboard/domain/usecases/store_expedition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'expedition_event.dart';
part 'expedition_state.dart';

class ExpeditionBloc extends Bloc<ExpeditionEvent, ExpeditionState> {
  final FetchAllExpedition _fetchAllExpedition;
  final FetchExpeditionImages _fetchExpeditionImages;
  final FetchSingleExpedition _fetchSingleExpedition;
  final StoreExpedition _storeExpedition;
  final EndExpedition _endExpedition;

  ExpeditionBloc({
    required FetchAllExpedition fetchAllExpedition,
    required FetchExpeditionImages fetchExpeditionImages,
    required FetchSingleExpedition fetchSingleExpedition,
    required StoreExpedition storeExpedition,
    required EndExpedition endExpedition,
  })  : _fetchAllExpedition = fetchAllExpedition,
        _fetchExpeditionImages = fetchExpeditionImages,
        _fetchSingleExpedition = fetchSingleExpedition,
        _storeExpedition = storeExpedition,
        _endExpedition = endExpedition,
        super(ExpeditionInitial()) {
    on<ExpeditionEvent>((event, emit) => emit(ExpeditionLoading()));
    on<ExpeditionFetchAllExpedition>(_onFetchAllExpedition);
    on<ExpeditionFetchExpeditionImages>(_onFetchExpeditionImages);
    on<ExpeditionFetchSingleExpedition>(_onFetchSingleExpedition);
    on<ExpeditionStoreExpedition>(_onStoreExpedition);
    on<ExpeditionEndExpedition>(_onEndExpedition);
  }

  void _onFetchAllExpedition(
    ExpeditionFetchAllExpedition event,
    Emitter<ExpeditionState> emit,
  ) async {
    final res = await _fetchAllExpedition(NoParams());

    await res.fold(
      (l) async {
        emit(ExpeditionFailure(l.message));
      },
      (r) async {
        try {
          await emit.forEach<List<ExpeditionRecord>>(
            r,
            onData: (expedition) => ExpeditionDisplaySuccess(expedition),
            onError: (error, stackTrace) => ExpeditionFailure(error.toString()),
          );
        } catch (error) {
          emit(ExpeditionFailure('Unexpected error: $error'));
        }
      },
    );
  }

  void _onFetchExpeditionImages(ExpeditionFetchExpeditionImages event,
      Emitter<ExpeditionState> emit) async {
    final res = await _fetchExpeditionImages(
      FetchExpeditionImagesParams(
        expeditionId: event.expeditionId,
      ),
    );

    res.fold(
      (l) => emit(ExpeditionFailure(l.message)),
      (r) => emit(ExpeditionImagesSuccess(r)),
    );
  }

  void _onFetchSingleExpedition(ExpeditionFetchSingleExpedition event,
      Emitter<ExpeditionState> emit) async {
    final res = await _fetchSingleExpedition(
      FetchSingleExpeditionParams(expeditionId: event.expeditionId),
    );

    res.fold(
      (l) => emit(ExpeditionFailure(l.message)),
      (r) => emit(ExpeditionRecordSuccess(r)),
    );
  }

  void _onStoreExpedition(
      ExpeditionStoreExpedition event, Emitter<ExpeditionState> emit) async {
    final res = await _storeExpedition(
      StoreExpeditionParams(event.expeditionIdentifier),
    );

    res.fold(
      (l) => emit(ExpeditionFailure(l.message)),
      (r) => emit(ExpeditionStoreSuccess(r)),
    );
  }

  void _onEndExpedition(
      ExpeditionEndExpedition event, Emitter<ExpeditionState> emit) async {
    final res = await _endExpedition(
      EndExpeditionParams(
        expeditionId: event.expeditionId,
      ),
    );

    res.fold(
      (l) => emit(ExpeditionFailure(l.message)),
      (r) => emit(ExpeditionEndSuccess(r)),
    );
  }
}
