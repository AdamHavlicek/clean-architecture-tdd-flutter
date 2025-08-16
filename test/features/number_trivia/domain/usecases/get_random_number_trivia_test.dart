import 'package:clean_architecture_tdd_course/core/domain/unsigned_integer.dart';
import 'package:clean_architecture_tdd_course/core/error/failures.dart';
import 'package:clean_architecture_tdd_course/core/usecases/usecase.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_random_number_trivia_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NumberTriviaRepository>()])
void main() {
  late GetRandomNumberTrivia tUseCase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    provideDummy(
      TaskEither<Failure, NumberTrivia>.left(
        const UnexpectedFailure('Dummy Value'),
      ),
    );

    mockNumberTriviaRepository = MockNumberTriviaRepository();

    tUseCase = GetRandomNumberTrivia(repository: mockNumberTriviaRepository);
  });

  test('should get trivia from the repository', () async {
    // Arrange
    const int expectedNumber = 1;
    final expectedNumberTrivia = NumberTrivia(
      number: UnsignedInteger(expectedNumber.toString()),
      text: 'test',
    );
    final expectedResult = Right<Failure, NumberTrivia>(expectedNumberTrivia);

    // Mock
    when(
      mockNumberTriviaRepository.getRandomNumberTrivia(),
    ).thenReturn(TaskEither.right(expectedNumberTrivia));

    // Act
    final result = await tUseCase(noParams);

    // Assert
    expect(result, expectedResult);
    verify(mockNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
