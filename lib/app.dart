import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'core/components/inherited_widget_access.dart';
import 'core/store/app_state.dart';
import 'core/store/app_store.dart';
import 'features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'injection_container.dart';

/// Wrapper for building app with theme
class AppWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const App();
  }
}

/// {{@template app}}
/// Main Widget which starts the whole application
/// {{@end template}}
class App extends StatelessWidget {
  /// Theme with which to build the [App]

  /// {@macro app}
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final store = getIt<AppStore>();

    return InheritedWidgetAccess<AppStore>(
      value: store,
      child: StoreProvider<AppState>(
        store: store,
        child: MaterialApp(
          title: 'Number Trivia',
          theme: ThemeData(
            colorSchemeSeed: Colors.green,
          ),
          debugShowCheckedModeBanner: false,
          home: const NumberTriviaPage(),
        ),
      ),
    );
  }
}
