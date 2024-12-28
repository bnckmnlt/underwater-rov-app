import 'package:embedded_rov_v2/core/error/failure.dart';
import 'package:embedded_rov_v2/core/usecase/usecase.dart';
import 'package:embedded_rov_v2/features/dashboard/domain/entities/expedition.dart';
import 'package:embedded_rov_v2/features/dashboard/domain/repositories/expedition_repository.dart';
import 'package:fpdart/fpdart.dart';

class FetchSingleExpedition
    implements UseCase<ExpeditionRecord, FetchSingleExpeditionParams> {
  final ExpeditionRepository expeditionRepository;

  const FetchSingleExpedition(this.expeditionRepository);

  @override
  Future<Either<Failure, ExpeditionRecord>> call(
      FetchSingleExpeditionParams params) async {
    return await expeditionRepository.fetchSingleExpedition(
      expeditionId: params.expeditionId,
    );
  }
}

class FetchSingleExpeditionParams {
  final int expeditionId;

  FetchSingleExpeditionParams({
    required this.expeditionId,
  });
}
