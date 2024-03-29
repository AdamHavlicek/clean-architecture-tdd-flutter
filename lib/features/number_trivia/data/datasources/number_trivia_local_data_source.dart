import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/number_trivia_dto.dart';

abstract interface class NumberTriviaLocalDataSource {
  IOEither<Exception, NumberTriviaDTO> getLastNumberTrivia();

  Task<Unit> cacheNumberTrivia(NumberTriviaDTO triviaToCache);
}

@LazySingleton(as: NumberTriviaLocalDataSource)
final class NumberTriviaLocalDataSourceImpl
    implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;
  final cacheKey = 'CACHED_NUMBER_TRIVIA';

  NumberTriviaLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  @override
  IOEither<Exception, NumberTriviaDTO> getLastNumberTrivia() {
    return IOEither<Exception, String>.fromNullable(
      sharedPreferences.getString(cacheKey),
      () => const CacheException(message: 'Cache is empty'),
    ).map(
      (jsonString) => NumberTriviaDTO.fromJson(
        json.decode(jsonString) as Map<String, dynamic>,
      ),
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
