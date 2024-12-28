import 'package:embedded_rov_v2/core/error/failure.dart';
import 'package:embedded_rov_v2/core/usecase/usecase.dart';
import 'package:embedded_rov_v2/features/dashboard/domain/repositories/expedition_repository.dart';
import 'package:fpdart/fpdart.dart';

class StoreExpedition implements UseCase<String, StoreExpeditionParams> {
  final ExpeditionRepository expeditionRepository;

  const StoreExpedition(this.expeditionRepository);

  @override
  Future<Either<Failure, String>> call(StoreExpeditionParams params) async {
    return await expeditionRepository.storeExpedition(
      expeditionIdentifier: params.expeditionIdentifier,
    );
  }
}

class StoreExpeditionParams {
  final String expeditionIdentifier;

  StoreExpeditionParams(this.expeditionIdentifier);
}
