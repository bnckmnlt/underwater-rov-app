import 'package:embedded_rov_v2/core/error/failure.dart';
import 'package:embedded_rov_v2/core/usecase/usecase.dart';
import 'package:embedded_rov_v2/features/dashboard/domain/entities/image.dart';
import 'package:embedded_rov_v2/features/dashboard/domain/repositories/expedition_repository.dart';
import 'package:fpdart/fpdart.dart';

class FetchExpeditionImages
    implements UseCase<List<ImageRecord>, FetchExpeditionImagesParams> {
  final ExpeditionRepository expeditionRepository;

  const FetchExpeditionImages(this.expeditionRepository);

  @override
  Future<Either<Failure, List<ImageRecord>>> call(
      FetchExpeditionImagesParams params) async {
    return await expeditionRepository.fetchExpeditionImages(
      expeditionId: params.expeditionId,
    );
  }
}

class FetchExpeditionImagesParams {
  final int expeditionId;

  FetchExpeditionImagesParams({
    required this.expeditionId,
  });
}
