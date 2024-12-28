part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initExpedition();

  await dotenv.load(fileName: ".env");

  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  serviceLocator.registerLazySingleton(() => supabase.client);
  serviceLocator.registerLazySingleton(() => MqttService());

  await serviceLocator<MqttService>().connect();

  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(
      serviceLocator(),
    ),
  );
}

void _initExpedition() {
  serviceLocator
    ..registerFactory<ExpeditionRemoteDataSource>(
      () => ExpeditionRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<ExpeditionRepository>(
      () => ExpeditionRepositoryImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => FetchAllExpedition(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => FetchSingleExpedition(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => FetchExpeditionImages(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => ExpeditionBloc(
        fetchAllExpedition: serviceLocator(),
        fetchExpeditionImages: serviceLocator(),
        fetchSingleExpedition: serviceLocator(),
      ),
    );
}
