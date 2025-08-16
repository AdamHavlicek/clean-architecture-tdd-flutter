import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../store/app_state.dart';

typedef StateSelector<State> = State Function(AppState state);
typedef StateBuilder<State> = Widget Function(
  BuildContext context,
  State state,
);
typedef ShouldRebuild<State> = bool Function(State state);

final class AppStoreConnector<State_> extends StatelessWidget {
  final StateSelector<State_> selector;
  final StateBuilder<State_> builder;
  final ShouldRebuild<State_>? shouldRebuild;

  const AppStoreConnector({
    required this.selector,
    required this.builder,
    this.shouldRebuild,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, State_>(
      converter: (store) => selector(store.state),
      distinct: true,
      builder: builder,
      ignoreChange: (state) => !(shouldRebuild?.call(selector(state)) ?? true),
    );
  }
}
