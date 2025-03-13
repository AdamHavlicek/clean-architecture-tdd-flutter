import 'package:fpdart/fpdart.dart';
import 'package:reselect/reselect.dart';

import '../../../../core/store/app_state.dart';
import 'number_trivia_state.dart';

final numberTriviaStateSelector =
    createSelector1<AppState, NumberTriviaState, NumberTriviaState>(
  (state) => state.numberTriviaState,
  identity,
);
