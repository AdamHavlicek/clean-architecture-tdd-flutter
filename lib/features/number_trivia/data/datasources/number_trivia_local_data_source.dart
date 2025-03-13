import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/extensions/task_option.dart';
import '../models/number_trivia_dto.dart';

abstract interface class NumberTriviaLocalDataSource {
  TaskEither<Exception, NumberTriviaDTO> getLastNumberTrivia();

  Task<Unit> cacheNumberTrivia(NumberTriviaDTO triviaToCache);
}

@LazySingleton(as: NumberTriviaLocalDataSource)
final class NumberTriviaLocalDataSourceImpl
    implements NumberTriviaLocalDataSource {
  final SharedPreferencesAsync sharedPreferences;
  final cacheKey = 'CACHED_NUMBER_TRIVIA';

  NumberTriviaLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  @override
  TaskEither<Exception, NumberTriviaDTO> getLastNumberTrivia() {
    return taskEitherFromNullable(
      () => sharedPreferences.getString(cacheKey),
    )
        .toTaskEither<Exception>(
          () => const CacheException(message: 'Cache is empty'),
        )
        .map(
          (jsonString) => json.decode(jsonString) as Map<String, Object?>,
        )
        .map(
          NumberTriviaDTO.fromJson,
        );
  }

  @override
  Task<Unit> cacheNumberTrivia(NumberTriviaDTO triviaToCache) {
    return Task.of(
      json.encode(triviaToCache.toJson()),
    )
        .flatMap(
          (jsonString) => Task(
            () => sharedPreferences.setString(cacheKey, jsonString),
          ),
        )
        .map((_) => unit);
  }
}
