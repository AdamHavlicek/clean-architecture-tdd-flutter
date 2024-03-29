import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/data/converters.dart';
import '../../domain/entities/number_trivia.dart';
import 'number_trivia_dto.auto_mappr.dart';

part 'number_trivia_dto.freezed.dart';
part 'number_trivia_dto.g.dart';


@AutoMappr([
  MapType<NumberTrivia, NumberTriviaDTO>(
    reverse: true
  ),
])
final class NumberTriviaDTOMapper extends $NumberTriviaDTOMapper {
  const NumberTriviaDTOMapper();
}

@Freezed(
    map: FreezedMapOptions.none,
    when: FreezedWhenOptions.none
)
sealed class NumberTriviaDTO with _$NumberTriviaDTO {
  static const NumberTriviaDTOMapper _mapper = NumberTriviaDTOMapper();

  const factory NumberTriviaDTO({
    required String text,
    @NumberConvertor() required int number,
  }) = _NumberTriviaDTO;

  const NumberTriviaDTO._();

  factory NumberTriviaDTO.fromJson(Map<String, dynamic> json) =>
      _NumberTriviaDTO.fromJson(json);

  NumberTrivia toDomain() {
    return _mapper.convert(this);
  }
}
