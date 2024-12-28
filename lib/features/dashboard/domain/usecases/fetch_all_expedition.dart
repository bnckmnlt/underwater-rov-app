import 'package:embedded_rov_v2/core/error/failure.dart';
import 'package:embedded_rov_v2/core/usecase/usecase.dart';
import 'package:embedded_rov_v2/features/dashboard/domain/entities/expedition.dart';
import 'package:embedded_rov_v2/features/dashboard/domain/repositories/expedition_repository.dart';
import 'package:fpdart/fpdart.dart';

class FetchAllExpedition
    implements UseCase<Stream<List<ExpeditionRecord>>, NoParams> {
  final ExpeditionRepository expeditionRepository;

  const FetchAllExpedition(this.expeditionRepository);

  @override
  Future<Either<Failure, Stream<List<ExpeditionRecord>>>> call(
      NoParams params) async {
    return await expeditionRepository.fetchExpeditions();
  }
}
