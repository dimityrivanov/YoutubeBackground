import 'package:get_it/get_it.dart';
import 'package:youtube_test/services/BillingService.dart';
import 'package:youtube_test/services/LocalStorageService.dart';
import 'package:youtube_test/services/player_service.dart';

GetIt locator = GetIt.instance;

Future setupLocator() async {
  var instance = await LocalStorageService.getInstance();
  final billingService = BillingService();
  billingService.initialize();

  locator.registerSingleton<LocalStorageService>(instance);
  locator.registerLazySingleton(() => PlayerService());
  locator.registerLazySingleton(() => billingService);
}
