import 'package:embedded_rov_v2/core/network/connection_checker.dart';
import 'package:embedded_rov_v2/core/secrets/app_secrets.dart';
import 'package:embedded_rov_v2/features/dashboard/data/datasources/expedition_remote_datasource.dart';
import 'package:embedded_rov_v2/features/dashboard/data/repositories/expedition_repository_impl.dart';
import 'package:embedded_rov_v2/features/dashboard/domain/repositories/expedition_repository.dart';
import 'package:embedded_rov_v2/features/dashboard/domain/usecases/fetch_all_expedition.dart';
import 'package:embedded_rov_v2/features/dashboard/domain/usecases/fetch_expedition_images.dart';
import 'package:embedded_rov_v2/features/dashboard/domain/usecases/fetch_single_expedition.dart';
import 'package:embedded_rov_v2/features/dashboard/domain/usecases/store_expedition.dart';
import 'package:embedded_rov_v2/features/dashboard/presentation/bloc/expedition_bloc/expedition_bloc.dart';
import 'package:embedded_rov_v2/mqtt_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'init_dependencies.main.dart';
