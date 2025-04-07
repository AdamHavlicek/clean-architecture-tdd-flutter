import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/concrete_number_trivia_params.dart';

part 'number_trivia_form_state.freezed.dart';

@Freezed()
sealed class NumberTriviaFormState with _$NumberTriviaFormState {
  const factory NumberTriviaFormState({
    required ConcreteNumberTriviaParams params,
  }) = _NumberTriviaFormState;

  const NumberTriviaFormState._();

  static NumberTriviaFormState initial = NumberTriviaFormState(
    params: ConcreteNumberTriviaParams.empty(),
  );
}
