import 'dart:convert';

import 'package:clean_architecture_tdd_course/core/error/exceptions.dart';
import 'package:clean_architecture_tdd_course/core/error/failures.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/models/number_trivia_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SharedPreferences>(),
])
void main() {
  late MockSharedPreferences mockSharedPreferences;
  late NumberTriviaLocalDataSourceImpl tDataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    tDataSource = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group(
    'getLastNumberTrivia',
    () {
      setUp(() {});

      test(
        'should return NumberTrivia from SharedPreferences when there is one in the cache',
        () async {
          // Arrange
          final String fixtureTrivia = fixture('trivia_cached.json');

          const expectedKey = 'CACHED_NUMBER_TRIVIA';
          final expectedResult = Either<Failure, NumberTriviaDTO>.right(
            NumberTriviaDTO.fromJson(
              json.decode(fixtureTrivia) as Map<String, dynamic>,
            ),
          );

          // Mock
          when(
            mockSharedPreferences.getString(any),
          ).thenReturn(
            fixtureTrivia,
          );

          // Act
          final result = tDataSource.getLastNumberTrivia().run();

          // Assert
          verify(mockSharedPreferences.getString(expectedKey)).called(1);
          expect(result, equals(expectedResult));
        },
      );

      test(
        'should throw a [CacheException] when there is not a cached value',
        () async {
          // Arrange
          // Mock
          when(
            mockSharedPreferences.getString(any),
          ).thenReturn(
            null,
          );

          // Act
          final Exception result = tDataSource.getLastNumberTrivia().run().fold(
                identity,
                (_) => fail('should return [CacheException]'),
              );

          // Assert
          expect(result, isA<CacheException>());
        },
      );
    },
  );

  group(
    'cacheNumberTrivia',
    () {
      test(
        'should call [SharedPreferences to cache the data]',
        () async {
          // Arrange
          const expectedKey = 'CACHED_NUMBER_TRIVIA';
          const numberTriviaDTO = NumberTriviaDTO(text: 'test text', number: 1);
          final expectedValue = json.encode(numberTriviaDTO.toJson());

          // Mock
          when(
            mockSharedPreferences.setString(any, any),
          ).thenAnswer(
            (_) async => true,
          );

          // Act
          await tDataSource.cacheNumberTrivia(numberTriviaDTO).run();

          // Assert
          verify(mockSharedPreferences.setString(expectedKey, expectedValue))
              .called(1);
        },
      );
    },
  );
}
