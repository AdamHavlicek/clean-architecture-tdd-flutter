import 'package:fpdart/fpdart.dart';

TaskOption<T> taskEitherFromNullable<T>(Future<T?> Function() future) {
  return TaskOption<T>(() => future().then(Option.fromNullable));
}
