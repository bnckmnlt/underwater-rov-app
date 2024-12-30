import 'package:embedded_rov_v2/core/error/failure.dart';
import 'package:embedded_rov_v2/features/dashboard/domain/entities/expedition.dart';
import 'package:embedded_rov_v2/features/dashboard/domain/entities/image.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ExpeditionRepository {
  Future<Either<Failure, Stream<List<ExpeditionRecord>>>> fetchExpeditions();

  Future<Either<Failure, ExpeditionRecord>> fetchSingleExpedition({
    required int expeditionId,
  });

  Future<Either<Failure, List<ImageRecord>>> fetchExpeditionImages({
    required int expeditionId,
  });

  Future<Either<Failure, String>> storeExpedition({
    required String expeditionIdentifier,
  });

  Future<Either<Failure, String>> endExpedition({
    required int expeditionId,
  });
}
