part of 'number_trivia_form.dart';

class NumberTriviaFormButtons extends StatelessWidget {
  const NumberTriviaFormButtons();

  Widget buildSearchButton(
    _DispatchAction dispatchAction,
    NumberTriviaFormState state,
  ) {
    final value = state.params.number.value;
    final onPressed = value.fold(
      (_) => null,
      (_) => dispatchAction,
    );
    final elevatedButton = ElevatedButton(
      onPressed: onPressed,
      child: const Text('Search'),
    );

    return elevatedButton;
  }

  @override
  Widget build(BuildContext context) {
    final store = AppStore.of(context);

    return AppStoreConnector<NumberTriviaFormState>(
      selector: numberTriviaFormStateSelector,
      builder: (context, state) {
        void dispatchConcrete() {
          FocusScope.of(context).unfocus();

          final params = numberTriviaFormStateSelector(store.state).params;

          store.dispatch(NumberTriviaDataAction.fetchConcrete(params));
        }

        void dispatchRandom() {
          FocusScope.of(context).unfocus();

          store.dispatch(const NumberTriviaDataAction.fetchRandom());
        }

        return Row(
          children: [
            Expanded(
              child: buildSearchButton(
                dispatchConcrete,
                state,
              ),
            ),
            const Gap(10),
            Expanded(
              child: ElevatedButton(
                onPressed: dispatchRandom,
                child: const Text('Get random trivia'),
              ),
            ),
          ],
        );
      },
    );
  }
}
