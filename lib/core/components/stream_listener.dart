import 'dart:async';

import 'package:flutter/material.dart';

typedef StreamListenerCallback<T> = void Function(T value);

final class StreamListener<T> extends StatefulWidget {
  final Stream<T> stream;
  final StreamListenerCallback<T> listener;
  final Widget child;

  const StreamListener({
    super.key,
    required this.stream,
    required this.listener,
    required this.child,
  });

  @override
  StreamListenerState<T> createState() => StreamListenerState<T>();
}

final class StreamListenerState<T> extends State<StreamListener<T>> {
  late final StreamSubscription<T> _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget.stream.listen(widget.listener);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
