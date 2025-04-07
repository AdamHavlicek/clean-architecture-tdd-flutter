import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network.dart';
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
  InternetConnection get connectionChecker {
    final Iterable<InternetCheckOption> addresses = ADDRESS_OPTIONS_LIST.map(
      (options) => InternetCheckOption(
        uri: options.uri,
        timeout: options.timeout,
      ),
    );

    return InternetConnection.createInstance(
      customCheckOptions: addresses.toList(growable: false),
    );
  }

  @lazySingleton
  NetworkInfo networkInfo(InternetConnection connectionChecker) {
    return NetworkInfoImpl(
      connectionChecker: connectionChecker,
      onDataListenerFactory: NetworkInfoImpl.onDataConnectionCheckerFactory,
      isConnectedCompleterFactory: Completer.sync,
    );
  }

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
