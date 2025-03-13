import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/domain/unsigned_integer.dart';

part 'concrete_number_trivia_params.freezed.dart';

@Freezed()
sealed class ConcreteNumberTriviaParams with _$ConcreteNumberTriviaParams {
  const factory ConcreteNumberTriviaParams({
    required UnsignedInteger number,
  }) = _ConcreteNumberTriviaParams;
  const ConcreteNumberTriviaParams._();

  factory ConcreteNumberTriviaParams.empty() {
    return ConcreteNumberTriviaParams(
      number: UnsignedInteger(''),
    );
  }
}
