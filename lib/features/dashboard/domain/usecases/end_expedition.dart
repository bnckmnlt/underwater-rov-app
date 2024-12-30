import 'package:embedded_rov_v2/core/error/failure.dart';
import 'package:embedded_rov_v2/core/usecase/usecase.dart';
import 'package:embedded_rov_v2/features/dashboard/domain/repositories/expedition_repository.dart';
import 'package:fpdart/fpdart.dart';

class EndExpedition implements UseCase<String, EndExpeditionParams> {
  final ExpeditionRepository expeditionRepository;

  const EndExpedition(this.expeditionRepository);

  @override
  Future<Either<Failure, String>> call(EndExpeditionParams params) async {
    return await expeditionRepository.endExpedition(
      expeditionId: params.expeditionId,
    );
  }
}

class EndExpeditionParams {
  final int expeditionId;

  EndExpeditionParams({required this.expeditionId});
}
