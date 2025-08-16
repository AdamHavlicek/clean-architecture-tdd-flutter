import 'package:flutter/material.dart';

import '../../../../core/components/store/app_store_connector.dart';
import '../../domain/entities/number_trivia.dart';
import '../store/number_trivia_data/number_trivia_data_store.dart';

part 'number_trivia_display.widgets.dart';

class NumberTriviaDisplay extends StatelessWidget {
  const NumberTriviaDisplay({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppStoreConnector<NumberTriviaDataState>(
      selector: numberTriviaDataSelector,
      builder: (context, state) {
        return switch (state) {
          LoadedState(:final trivia) => TriviaDisplay(
              trivia: trivia,
            ),
          LoadingState() => const LoadingWidget(),
          ErrorState(:final failure) => MessageDisplay(
              message: failure.message,
            ),
        };
      },
    );
  }
}
