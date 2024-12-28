import 'package:embedded_rov_v2/core/error/exception.dart';
import 'package:embedded_rov_v2/core/error/failure.dart';
import 'package:embedded_rov_v2/features/dashboard/data/datasources/expedition_remote_datasource.dart';
import 'package:embedded_rov_v2/features/dashboard/domain/entities/expedition.dart';
import 'package:embedded_rov_v2/features/dashboard/domain/entities/image.dart';
import 'package:embedded_rov_v2/features/dashboard/domain/repositories/expedition_repository.dart';
import 'package:fpdart/fpdart.dart';

class ExpeditionRepositoryImpl implements ExpeditionRepository {
  final ExpeditionRemoteDataSource remoteDataSource;

  const ExpeditionRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Stream<List<ExpeditionRecord>>>>
      fetchExpeditions() async {
    try {
      final expeditions = remoteDataSource.fetchExpeditions();

      return right(expeditions);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<ImageRecord>>> fetchExpeditionImages({
    required int expeditionId,
  }) async {
    try {
      final images = await remoteDataSource.fetchExpeditionImages(
        expeditionId: expeditionId,
      );

      return right(images);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, ExpeditionRecord>> fetchSingleExpedition(
      {required int expeditionId}) async {
    try {
      final expedition = await remoteDataSource.fetchSingleExpedition(
        expeditionId: expeditionId,
      );

      return right(expedition);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
