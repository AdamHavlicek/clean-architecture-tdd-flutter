import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

abstract interface class _RequiredActionTransform {
  Stream<dynamic> mapAction<State>(Stream<dynamic> actions, EpicStore<State> store);
}

/// Change of default [EpicClass] behavior
/// with filtering of any emitted null action
///
/// Extends this class and implement [mapAction]
///
/// If updating existing class implementation of [EpicClass],
/// simply change to extending [EpicFilteredClass] and rename
/// [call] to [mapAction]
abstract class EpicFilteredClass<State> extends EpicClass<State>
    implements _RequiredActionTransform {
  @override
  Stream<dynamic> call(Stream<dynamic> actions, EpicStore<State> store) {
    // This will filter any unhandled action emit in Epics
    return mapAction<State>(actions, store).whereNotNull();
  }
}

/// Mixin with same functionality as [EpicFilteredClass]
mixin EpicFilteredMixin<State> on EpicClass<State> {
  @override
  Stream<dynamic> call(Stream<dynamic> actions, EpicStore<State> store) {
    return super.call(actions, store).whereNotNull();
  }
}
