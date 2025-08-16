import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/domain/unsigned_integer.dart';

part 'number_trivia.freezed.dart';

@Freezed()
sealed class NumberTrivia with _$NumberTrivia {
  const factory NumberTrivia({
    required String text,
    required UnsignedInteger number,
  }) = _NumberTrivia;

  const NumberTrivia._();
}
