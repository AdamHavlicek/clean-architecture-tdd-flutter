import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract interface class NetworkInfo {
  Task<bool> get isConnected;
}

typedef _OnDataConnectionCheckerFactory = void Function(
  InternetStatus event,
)
    Function(Completer<bool> Function() completerFactory);

class NetworkInfoImpl implements NetworkInfo {
  /// Instance of [DataConnectionChecker] used to check
  /// if device has connection to the Internet by pinging preset servers
  final InternetConnection connectionChecker;
  late final StreamSubscription<InternetStatus> _connectionListener;
  late Completer<bool> _isConnected;

  /// {@macro network_info}
  NetworkInfoImpl({
    required this.connectionChecker,
    required _OnDataConnectionCheckerFactory onDataListenerFactory,
    required Completer<bool> Function() isConnectedCompleterFactory,
  }) : this._isConnected = isConnectedCompleterFactory()..complete(true) {
    this._connectionListener = connectionChecker.onStatusChange.listen(
      onDataListenerFactory(
        () => this._isConnected = isConnectedCompleterFactory(),
      ),
    );
  }

  @override
  Task<bool> get isConnected {
    return Task(() => _isConnected.future);
  }

  static _OnDataConnectionCheckerFactory get onDataConnectionCheckerFactory =>
      (completerFactory) => (internetStatus) {
            final completeValue = switch (internetStatus) {
              InternetStatus.disconnected => false,
              InternetStatus.connected => true,
            };
            completerFactory().complete(
              completeValue,
            );
          };

  @disposeMethod
  void dispose() {
    this._connectionListener.cancel();
  }
}
