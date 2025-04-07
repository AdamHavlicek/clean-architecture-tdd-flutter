import 'dart:async';

import 'package:clean_architecture_tdd_course/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'network_info_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<InternetConnection>(),
])
void main() {
  late MockInternetConnection mockInternetConnection;
  late Stream<InternetStatus> internetConnectionStatusStream;
  late Completer<bool> Function() isConnectedCompleter;

  late NetworkInfoImpl tNetworkInfo;

  setUp(
    () {
      mockInternetConnection = MockInternetConnection();
      internetConnectionStatusStream = Stream.value(
        InternetStatus.connected,
      );
      isConnectedCompleter = Completer.sync;

      when(
        mockInternetConnection.onStatusChange,
      ).thenAnswer(
        (_) => internetConnectionStatusStream,
      );

      tNetworkInfo = NetworkInfoImpl(
        connectionChecker: mockInternetConnection,
        onDataListenerFactory: (completerFactory) =>
            (_) => completerFactory().complete(true),
        isConnectedCompleterFactory: isConnectedCompleter,
      );
    },
  );

  tearDown(
    () {
      tNetworkInfo.dispose();
    },
  );

  test(
    'should forward the function call',
    () async {
      // Arrange
      const expectedResult = true;

      // Act
      final result = await tNetworkInfo.isConnected.run();

      // Assert
      expect(result, expectedResult);
    },
  );
}
