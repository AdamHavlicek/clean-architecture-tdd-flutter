import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../models/number_trivia_dto.dart';

abstract interface class NumberTriviaRemoteDataSource {
  TaskEither<Exception, NumberTriviaDTO> getConcreteNumberTrivia(int number);

  TaskEither<Exception, NumberTriviaDTO> getRandomNumberTrivia();
}

@LazySingleton(as: NumberTriviaRemoteDataSource)
final class NumberTriviaRemoteDataSourceImpl
    implements NumberTriviaRemoteDataSource {
  final Client httpClient;
  final Map<String, String> headers = {'Content-Type': 'application/json'};
  final String host = 'numberapi.com';
  final String scheme = 'http';

  Uri Function(String path) get concreteNumberUrl => _getBaseNumberApiUri;

  Uri get randomNumberUrl => _getBaseNumberApiUri('random');

  NumberTriviaRemoteDataSourceImpl({
    required this.httpClient,
  });

  Uri _getBaseNumberApiUri(String path) => Uri(
        scheme: scheme,
        host: host,
        path: path,
      );

  TaskEither<Exception, NumberTriviaDTO> _getTriviaFromUrl(
    Uri concreteOrRandomUrl,
  ) {
    return TaskEither<Exception, Response>.tryCatch(
            () => httpClient.get(
                  concreteOrRandomUrl,
                  headers: headers,
                ),
            (err, __) => UnexpectedServerException(
                  message: 'Unexpected Exception $err',
                ))
        .chainEither(
          (response) => Either.fromPredicate(
            response,
            (response) => response.statusCode == 200,
            (_) => const ServerException(message: 'Invalid Server Response'),
          ),
        )
        .map(
          (response) => NumberTriviaDTO.fromJson(json.decode(response.body) as Map<String, dynamic>),
        );
  }

  @override
  TaskEither<Exception, NumberTriviaDTO> getConcreteNumberTrivia(int number) =>
      _getTriviaFromUrl(concreteNumberUrl('$number'));

  @override
  TaskEither<Exception, NumberTriviaDTO> getRandomNumberTrivia() =>
      _getTriviaFromUrl(randomNumberUrl);
}
