import 'dart:async';

import 'package:clean_architecture_tdd_course/core/domain/unsigned_integer.dart';
import 'package:clean_architecture_tdd_course/core/error/failures.dart';
import 'package:clean_architecture_tdd_course/core/usecases/usecase.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/concrete_number_trivia_params.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/presentation/store/number_trivia_data/number_trivia_data_actions.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/presentation/store/number_trivia_data/number_trivia_data_epic.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/presentation/store/number_trivia_data/number_trivia_data_reducers.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/presentation/store/number_trivia_data/number_trivia_data_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';

import 'number_trivia_data_epic_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetConcreteNumberTrivia>(),
  MockSpec<GetRandomNumberTrivia>(),
])
void main() {
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late Store<NumberTriviaDataState> store;
  late NumberTriviaDataEpic<dynamic> tEpic;

  setUp(() {
    provideDummy<Either<Failure, NumberTrivia>>(
      Either.left(
        const UnexpectedFailure('Dummy Value'),
      ),
    );

    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();

    tEpic = NumberTriviaDataEpic<NumberTriviaDataState>(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
    );

    store = Store<NumberTriviaDataState>(
      numberTriviaDataReducer,
      initialState: NumberTriviaDataState.initial,
      middleware: [
        EpicMiddleware<NumberTriviaDataState>(tEpic.call).call,
      ],
    );
  });

  test(
    'initial state should be empty',
    () {
      // Arrange
      const expectedState = NumberTriviaDataState.initial;

      // Act
      final result = store.state;

      // Assert
      expect(result, equals(expectedState));
    },
  );

  group('GetTriviaForConcreteNumber', () {
    const String validNumberString = '1';
    const int numberParsed = 1;
    const numberTrivia = NumberTrivia(
      text: 'test trivia',
      number: numberParsed,
    );
    const actionToInvoke = NumberTriviaDataAction.fetchConcrete;

    test(
      'should get data from the concrete use case',
      () async {
        // Arrange
        final expectedResult = ConcreteNumberTriviaParams(
          number: UnsignedInteger(validNumberString),
        );

        // Mock
        when(mockGetConcreteNumberTrivia(any)).thenAnswer(
          (_) async => const Right(numberTrivia),
        );

        // Act
        scheduleMicrotask(() {
          store.dispatch(actionToInvoke(expectedResult));
        });

        // Assert
        await untilCalled(mockGetConcreteNumberTrivia(any));
        verify(mockGetConcreteNumberTrivia(expectedResult)).called(1);
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // Arrange
        final params = ConcreteNumberTriviaParams(
          number: UnsignedInteger(validNumberString),
        );
        final action = NumberTriviaDataAction.fetchConcrete(params);
        const expectedStates = [
          NumberTriviaDataState.loading(),
          NumberTriviaDataState.loaded(numberTrivia),
        ];
        final result = store.onChange;

        // Mock
        when(mockGetConcreteNumberTrivia(any)).thenAnswer(
          (_) async => const Right(numberTrivia),
        );

        // Act
        scheduleMicrotask(() {
          store.dispatch(action);
        });

        // Assert
        expectLater(result, emitsInOrder(expectedStates));
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // Arrange
        final params = ConcreteNumberTriviaParams(
          number: UnsignedInteger(validNumberString),
        );
        final action = NumberTriviaDataAction.fetchConcrete(params);

        const expectedFailure = ServerFailure('Invalid Server Response');
        const expectedStates = [
          NumberTriviaDataState.loading(),
          NumberTriviaDataState.error(expectedFailure),
        ];

        final result = store.onChange;

        // Mock
        when(mockGetConcreteNumberTrivia(any)).thenAnswer(
          (_) async => const Left(expectedFailure),
        );

        // Act
        scheduleMicrotask(() {
          store.dispatch(action);
        });

        // Assert
        expectLater(result, emitsInOrder(expectedStates));
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        // Arrange
        final params = ConcreteNumberTriviaParams(
          number: UnsignedInteger(validNumberString),
        );
        final action = NumberTriviaDataAction.fetchConcrete(params);

        const expectedFailure = CacheFailure('Invalid Server Response');
        const expectedStates = [
          NumberTriviaDataState.loading(),
          NumberTriviaDataState.error(expectedFailure),
        ];

        final result = store.onChange;

        // Mock
        when(mockGetConcreteNumberTrivia(any)).thenAnswer(
          (_) async => const Left(expectedFailure),
        );

        // Act
        scheduleMicrotask(() {
          store.dispatch(action);
        });

        // Assert
        expectLater(result, emitsInOrder(expectedStates));
      },
    );
  });

  group('GetTriviaForRandomNumber', () {
    const numberTrivia = NumberTrivia(
      text: 'test trivia',
      number: 1,
    );
    const actionToInvoke = NumberTriviaDataAction.fetchRandom;

    test(
      'should get data from the concrete use case',
      () async {
        // Arrange
        const expectedResult = noParams;

        // Mock
        when(mockGetRandomNumberTrivia(any)).thenAnswer(
          (_) async => const Right(numberTrivia),
        );

        // Act
        scheduleMicrotask(() {
          store.dispatch(actionToInvoke());
        });

        // Assert
        await untilCalled(mockGetRandomNumberTrivia(any));
        verify(mockGetRandomNumberTrivia(expectedResult)).called(1);
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // Arrange
        const expectedStates = [
          NumberTriviaDataState.loading(),
          NumberTriviaDataState.loaded(numberTrivia),
        ];
        final result = store.onChange;

        // Mock
        when(mockGetRandomNumberTrivia(any)).thenAnswer(
          (_) async => const Right(numberTrivia),
        );

        // Act
        scheduleMicrotask(() {
          store.dispatch(actionToInvoke());
        });

        // Assert
        expectLater(result, emitsInOrder(expectedStates));
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // Arrange
        const expectedFailure = ServerFailure('Invalid Server Response');
        const expectedStates = [
          NumberTriviaDataState.loading(),
          NumberTriviaDataState.error(expectedFailure),
        ];

        final result = store.onChange;

        // Mock
        when(mockGetRandomNumberTrivia(any)).thenAnswer(
          (_) async => const Left(expectedFailure),
        );

        // Act
        scheduleMicrotask(() {
          store.dispatch(actionToInvoke());
        });

        // Assert
        expectLater(result, emitsInOrder(expectedStates));
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        // Arrange
        const expectedFailure = CacheFailure('Invalid Server Response');
        const expectedStates = [
          NumberTriviaDataState.loading(),
          NumberTriviaDataState.error(expectedFailure),
        ];

        final result = store.onChange;

        // Mock
        when(mockGetRandomNumberTrivia(any)).thenAnswer(
          (_) async => const Left(expectedFailure),
        );

        // Act
        scheduleMicrotask(() {
          store.dispatch(actionToInvoke());
        });

        // Assert
        expectLater(result, emitsInOrder(expectedStates));
      },
    );
  });
}
