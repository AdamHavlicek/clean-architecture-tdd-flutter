import 'package:injectable/injectable.dart';
import 'package:redux_epics/redux_epics.dart';

import '../../features/number_trivia/presentation/store/number_trivia_data/number_trivia_data_epic.dart';
import 'app_state.dart';

@lazySingleton
final class AppEpic {
  final NumberTriviaDataEpic numberTriviaDataEpic;

  AppEpic({
    required this.numberTriviaDataEpic,
  });

  Epic<AppState> get combinedEpic => combineEpics([
        numberTriviaDataEpic.call,
      ]);
}
