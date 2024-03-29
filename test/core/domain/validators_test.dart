import 'package:clean_architecture_tdd_course/core/domain/validators.dart';
import 'package:clean_architecture_tdd_course/core/error/failures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

typedef _StringToIntValidator = Either<Failure, int> Function(String);

void main() {
  group('validateUnsignedInteger', () {
    late _StringToIntValidator inputValidator;

    setUp(() {
      inputValidator = validateUnsignedInteger;
    });
    test(
        'should return an integer when the string represents an unsigned integer',
        () {
      // Arrange
      const String string = '1';
      const expectedResult = Right<Failure, int>(1);

      // Act
      final result = inputValidator(string);

      // Assert
      expect(result, expectedResult);
    });

    test('should return a [Failure] when the string is not an integer', () {
      // Arrange
      const String string = '1.11';
      const expectedResult = Left<Failure, int>(InvalidInputFailure('Must be an integer'));

      // Act
      final result = inputValidator(string);

      // Assert
      expect(result, expectedResult);
    });

    test('should return a [Failure] when the string is a negative integer', () {
      // Arrange
      const String string = '-1';
      const expectedResult =
          Left<Failure, int>(InvalidInputFailure('Must be an unsigned integer'));

      // Act
      final result = inputValidator(string);

      // Assert
      expect(result, expectedResult);
    });

    test('should return a [Failure] when the string is empty', () {
      // Arrange
      const String string = ' ';
      const expectedResult = Left<Failure, String>(
        InvalidInputFailure('Must be a non-empty string'),
      );

      // Act
      final result = inputValidator(string);

      // Assert
      expect(result, expectedResult);
    });
  });
}
