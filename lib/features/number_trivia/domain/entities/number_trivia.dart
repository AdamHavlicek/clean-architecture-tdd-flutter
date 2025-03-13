import 'package:freezed_annotation/freezed_annotation.dart';

part 'number_trivia.freezed.dart';

@Freezed()
sealed class NumberTrivia with _$NumberTrivia {
  const factory NumberTrivia({
    required String text,
    required int number,
  }) = _NumberTrivia;

  const NumberTrivia._();
}
