import 'number_trivia_form_store.dart';

NumberTriviaFormState numberTriviaFormReducer(
  NumberTriviaFormState state,
  dynamic action,
) {
  if (action is NumberTriviaFormAction) {
    return switch (action) {
      NumberChangedAction(:final number) => state.copyWith.params(
          number: number,
        ),
    };
  }

  return state;
}
