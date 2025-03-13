import 'dart:convert';

import 'package:clean_architecture_tdd_course/core/error/exceptions.dart';
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
  MockSpec<SharedPreferencesAsync>(),
])
void main() {
  late MockSharedPreferencesAsync mockSharedPreferencesAsync;
  late NumberTriviaLocalDataSourceImpl tDataSource;

  setUp(() {
    mockSharedPreferencesAsync = MockSharedPreferencesAsync();
    tDataSource = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferencesAsync,
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
          final expectedResult = Either<Exception, NumberTriviaDTO>.right(
            NumberTriviaDTO.fromJson(
              json.decode(fixtureTrivia) as Map<String, dynamic>,
            ),
          );

          // Mock
          when(
            mockSharedPreferencesAsync.getString(any),
          ).thenAnswer(
            (_) async => fixtureTrivia,
          );

          // Act
          final Either<Exception, NumberTriviaDTO> result = await tDataSource
              .getLastNumberTrivia().run();

          // Assert
          verify(mockSharedPreferencesAsync.getString(expectedKey)).called(1);
          expect(result, equals(expectedResult));
        },
      );

      test(
        'should throw a [CacheException] when there is not a cached value',
        () async {
          // Arrange
          // Mock
          when(
            mockSharedPreferencesAsync.getString(any),
          ).thenAnswer(
            (_) async => null,
          );

          // Act
          final Exception result = await tDataSource.getLastNumberTrivia().match(
                identity,
                (_) => fail('should return [CacheException]'),
              ).run();

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
            mockSharedPreferencesAsync.setString(any, any),
          ).thenAnswer(
            (_) async => true,
          );

          // Act
          await tDataSource.cacheNumberTrivia(numberTriviaDTO).run();

          // Assert
          verify(mockSharedPreferencesAsync.setString(expectedKey, expectedValue))
              .called(1);
        },
      );
    },
  );
}
