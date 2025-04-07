import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/repositories/number_trivia_repository.dart';
import '../datasources/number_trivia_local_data_source.dart';
import '../datasources/number_trivia_remote_data_source.dart';
import '../models/number_trivia_dto.dart';

typedef _ConcreteOrRandomChooser = TaskEither<Exception, NumberTriviaDTO>
    Function();

@LazySingleton(as: NumberTriviaRepository)
final class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaLocalDataSource localDataSource;
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  TaskEither<Failure, NumberTrivia> getConcreteNumberTrivia(int number) {
    return _getTrivia(
      () => remoteDataSource.getConcreteNumberTrivia(number),
    );
  }

  @override
  TaskEither<Failure, NumberTrivia> getRandomNumberTrivia() {
    return _getTrivia(remoteDataSource.getRandomNumberTrivia);
  }

  TaskEither<Failure, NumberTrivia> _hitCache() {
    return localDataSource.getLastNumberTrivia().bimap(
          (exception) => switch (exception) {
            final BaseException e => Failure.fromBaseException(e),
            _ => const UnexpectedFailure(),
          },
          (triviaDto) => triviaDto.toDomain(),
        );
  }

  TaskEither<Failure, NumberTrivia> _hitNetwork(
    _ConcreteOrRandomChooser getConcreteOrRandom,
  ) {
    return getConcreteOrRandom()
        .bimap(
          (exception) => switch (exception) {
            final BaseException e => Failure.fromBaseException(e),
            _ => const UnexpectedFailure(),
          },
          identity,
        )
        .chainFirst(
          (triviaDto) => TaskEither.fromTask(
            localDataSource.cacheNumberTrivia(triviaDto),
          ),
        )
        .map(
          (triviaDto) => triviaDto.toDomain(),
        );
  }

  TaskEither<Failure, NumberTrivia> _getTrivia(
    _ConcreteOrRandomChooser getConcreteOrRandom,
  ) {
    final triviaOrFailure = networkInfo.isConnected.map(
      (isConnected) => switch (isConnected) {
        false => _hitCache(),
        true => _hitNetwork(getConcreteOrRandom),
      },
    );

    return TaskEither.flatten(triviaOrFailure.toTaskEither());
  }
}
