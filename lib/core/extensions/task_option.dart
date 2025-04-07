import 'package:fpdart/fpdart.dart';

extension TaskOptionExtensions<T> on TaskOption<T> {
  static TaskOption<T> fromNullableAsync<T>(Future<T?> Function()
  future) {
    return TaskOption<T>(() => future().then(Option.fromNullable));
  }
}

