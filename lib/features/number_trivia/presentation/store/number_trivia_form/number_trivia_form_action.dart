import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/domain/unsigned_integer.dart';

part 'number_trivia_form_action.freezed.dart';

@Freezed(
  map: FreezedMapOptions.none,
  when: FreezedWhenOptions.none
)
sealed class NumberTriviaFormAction with _$NumberTriviaFormAction {
  const NumberTriviaFormAction._();

  const factory NumberTriviaFormAction.numberChanged(UnsignedInteger number) =
      NumberChangedAction;
}
