import 'package:embedded_rov_v2/core/error/exception.dart';
import 'package:embedded_rov_v2/features/dashboard/data/models/expedition_model.dart';
import 'package:embedded_rov_v2/features/dashboard/data/models/image_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class ExpeditionRemoteDataSource {
  Stream<List<ExpeditionModel>> fetchExpeditions();

  Future<ExpeditionModel> fetchSingleExpedition({
    required int expeditionId,
  });

  Future<List<ImageModel>> fetchExpeditionImages({
    required int expeditionId,
  });

  Future<String> storeExpedition({
    required String expeditionIdentifier,
  });
}

class ExpeditionRemoteDataSourceImpl implements ExpeditionRemoteDataSource {
  final SupabaseClient supabaseClient;

  ExpeditionRemoteDataSourceImpl(this.supabaseClient);

  @override
  Stream<List<ExpeditionModel>> fetchExpeditions() {
    try {
      final expeditionListStream = supabaseClient
          .from("expedition")
          .stream(primaryKey: ["id"])
          .order("created_at", ascending: false)
          .limit(10);

      return expeditionListStream.map<List<ExpeditionModel>>((expeditionList) {
        final expeditions = expeditionList
            .map<ExpeditionModel>(
                (expedition) => ExpeditionModel.fromJson(expedition))
            .toList();

        return expeditions;
      });
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ExpeditionModel> fetchSingleExpedition(
      {required int expeditionId}) async {
    try {
      final response = await supabaseClient
          .from('expedition')
          .select('*, image(*)')
          .eq('id', expeditionId)
          .single();

      return ExpeditionModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ImageModel>> fetchExpeditionImages(
      {required int expeditionId}) async {
    try {
      final expeditionImages = await supabaseClient
          .from("image")
          .select()
          .eq("expedition_id", expeditionId)
          .order("created_at", ascending: false);
      return (expeditionImages as List)
          .map((image) => ImageModel.fromJson(image))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> storeExpedition({required String expeditionIdentifier}) {
    // TODO: implement storeExpedition
    throw UnimplementedError();
  }
}
