import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import 'package:rxdart/rxdart.dart';

import '../components/inherited_widget_access.dart';
import '../extensions/stream_changes.dart';
import 'app_reducer.dart';
import 'app_state.dart';
import 'change.dart';

final class AppStore extends Store<AppState> {
  AppStore({
    required List<Middleware<AppState>> middleware,
  }) : super(
          appReducer,
          distinct: true,
          initialState: AppState.initial,
          middleware: [...middleware],
        );

  final BehaviorSubject<dynamic> _actionsSubject = BehaviorSubject();

  Stream<dynamic> get actions =>
      _actionsSubject.stream.where((event) => event != null);

  @override
  dynamic dispatch(dynamic action) {
    _actionsSubject.add(action);

    return super.dispatch(action);
  }

  Stream<Change<AppState>> get changes => onChange.changes;

  @override
  Future<dynamic> teardown() async {
    _actionsSubject.close();

    return super.teardown();
  }

  static AppStore of(BuildContext context) {
    return InheritedWidgetAccess.of<AppStore>(context).value;
  }
}
