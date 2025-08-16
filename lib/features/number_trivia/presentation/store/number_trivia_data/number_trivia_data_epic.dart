import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/store/app_state.dart';
import '../../../../../core/store/epic_filtered_class.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/number_trivia.dart';
import '../../../domain/usecases/get_concrete_number_trivia.dart';
import '../../../domain/usecases/get_random_number_trivia.dart';
import '../../models/concrete_number_trivia_params.dart';
import 'number_trivia_data_actions.dart';

typedef _UseCaseInvoke = Future<Either<Failure, NumberTrivia>> Function();

@lazySingleton
final class NumberTriviaDataEpic extends EpicFilteredClass<AppState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;

  NumberTriviaDataEpic({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
  });

  Stream<NumberTriviaDataAction> _handleConcrete(
      ConcreteNumberTriviaParams params) {
    return _handleAction(() => getConcreteNumberTrivia(params));
  }

  Stream<NumberTriviaDataAction> _handleRandom() {
    return _handleAction(() => getRandomNumberTrivia(noParams));
  }

  Stream<NumberTriviaDataAction> _handleAction(_UseCaseInvoke useCase) async* {
    final triviaOrFailure = await useCase();

    yield triviaOrFailure.fold(
      NumberTriviaDataAction.fetchingFailed,
      NumberTriviaDataAction.fetchingSuccess,
    );
  }

  @override
  Stream<dynamic> mapAction<State_>(Stream<dynamic> actions, EpicStore<State_>
  store) {
    return actions.whereType<NumberTriviaDataAction>().switchMap(
      (action) async* {
        yield* switch (action) {
          FetchConcreteAction(:final params) => _handleConcrete(params),
          FetchRandomAction() => _handleRandom(),
          _ => const Stream.empty(),
        };
      },
    );
  }
}
