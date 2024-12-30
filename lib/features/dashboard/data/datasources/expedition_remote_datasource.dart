import 'dart:convert';

import 'package:embedded_rov_v2/core/error/exception.dart';
import 'package:embedded_rov_v2/features/dashboard/data/models/expedition_model.dart';
import 'package:embedded_rov_v2/features/dashboard/data/models/image_model.dart';
import 'package:http/http.dart' as http;
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

  Future<String> endExpedition({
    required int expeditionId,
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
  Future<String> storeExpedition({
    required String expeditionIdentifier,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("https://thinkio.me/expedition"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'expeditionIdentifier': expeditionIdentifier,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)["expeditionIdentifier"].toString();
      } else {
        throw ServerException(jsonDecode(response.body)["message"].toString());
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> endExpedition({
    required int expeditionId,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse("https://thinkio.me/expedition/${expeditionId.toString()}"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'status': 'completed',
        }),
      );

      print(response);

      if (response.statusCode == 200) {
        return jsonDecode(response.body)["expeditionIdentifier"].toString();
      } else {
        throw ServerException(jsonDecode(response.body)["message"].toString());
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
