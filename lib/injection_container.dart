import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/store/app_epic.dart';
import 'core/store/app_state.dart';
import 'core/store/app_store.dart';
import 'injection_container.config.dart';

final GetIt getIt = GetIt.instance;

@module
abstract class RegisterModule {
  @lazySingleton
  EpicMiddleware<AppState> get epicMiddleware {
    return EpicMiddleware<AppState>(
      getIt<AppEpic>().combinedEpic,
    );
  }

  @lazySingleton
  AppStore get store {
    return AppStore(
      middleware: [
        epicMiddleware.call,
        // ignore: inference_failure_on_instance_creation
        LoggingMiddleware.printer().call,
      ],
    );
  }

  @lazySingleton
  InternetConnectionChecker get internetConnectionChecker =>
      InternetConnectionChecker.createInstance();

  @lazySingleton
  http.Client get httpClient => http.Client();

  @lazySingleton
  SharedPreferencesAsync get preferences => SharedPreferencesAsync();
}

@InjectableInit(preferRelativeImports: true)
Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();

  getIt.init();
}
