import 'dart:convert';

import 'package:clean_architecture_tdd_course/core/domain/unsigned_integer.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/models/number_trivia_dto.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  group('fromJson', () {
    const tNumberTriviaDTO = NumberTriviaDTO(
      number: 1,
      text: 'Test Text',
    );

    test('should return a valid model when JSON number is an integer', () {
      // Arrange
      final jsonMap = json.decode(
        fixture('trivia.json'),
      ) as Map<String, dynamic>;

      // Act
      final result = NumberTriviaDTO.fromJson(jsonMap);

      // Assert
      expect(result, tNumberTriviaDTO);
    });

    test('should return a valid model when JSON number is an double', () {
      // Arrange
      final jsonMap = json.decode(
        fixture('trivia_double.json'),
      );

      // Act
      final result = NumberTriviaDTO.fromJson(jsonMap as Map<String, dynamic>);

      // Assert
      expect(result, tNumberTriviaDTO);
    });
  });

  group('toJson', () {
    const tNumberTriviaDTO = NumberTriviaDTO(number: 1, text: 'Test Text');

    test('should return a JSON map containing proper data', () {
      // Arrange
      final Map<String, dynamic> expectedResult = {
        'text': 'Test Text',
        'number': 1,
      };

      // Act
      final result = tNumberTriviaDTO.toJson();

      // Assert
      expect(result, expectedResult);
    });
  });

  group(
    'toDomain',
    () {
      test(
        'should return [NumberTrivia]',
        () {
          // Arrange
          const int expectedNumber = 1;
          const expectedText = 'Test text';
          final expectedUnsignedInteger = UnsignedInteger(expectedNumber.toString());

          const tNumberTrivia = NumberTriviaDTO(
            text: expectedText,
            number: expectedNumber,
          );

          // Act
          final result = tNumberTrivia.toDomain();

          // Assert
          expect(
            result,
            isA<NumberTrivia>()
                .having(
                  (numberTrivia) => numberTrivia.number,
                  'number',
                  equals(expectedUnsignedInteger),
                )
                .having(
                  (numberTrivia) => numberTrivia.text,
                  'text',
                  equals(expectedText),
                ),
          );
        },
      );
    },
  );
}
