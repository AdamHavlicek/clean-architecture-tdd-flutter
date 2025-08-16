import 'package:clean_architecture_tdd_course/core/domain/unsigned_integer.dart';
import 'package:clean_architecture_tdd_course/core/error/failures.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/presentation/models/concrete_number_trivia_params.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_concrete_number_trivia_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NumberTriviaRepository>()])
void main() {
  late GetConcreteNumberTrivia tUseCase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    provideDummy(
      TaskEither<Failure, NumberTrivia>.left(
        const UnexpectedFailure('Dummy Value'),
      ),
    );

    mockNumberTriviaRepository = MockNumberTriviaRepository();

    tUseCase = GetConcreteNumberTrivia(repository: mockNumberTriviaRepository);
  });

  test('should get trivia for the number from the repository', () async {
    // Arrange
    const int expectedNumber = 1;
    final expectedNumberTrivia = NumberTrivia(
      number: UnsignedInteger(expectedNumber.toString()),
      text: 'test',
    );
    final expectedResult = Right<Failure, NumberTrivia>(expectedNumberTrivia);

    // Mock
    when(mockNumberTriviaRepository.getConcreteNumberTrivia(any))
        .thenReturn(TaskEither.right(expectedNumberTrivia));

    // Act
    final result = await tUseCase(ConcreteNumberTriviaParams(
      number: UnsignedInteger(expectedNumber.toString()),
    ));

    // Assert
    expect(result, expectedResult);
    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(expectedNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
