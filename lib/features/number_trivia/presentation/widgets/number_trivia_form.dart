import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/components/store/store.dart';
import '../../../../core/domain/unsigned_integer.dart';
import '../../../../core/store/app_store.dart';
import '../store/number_trivia_data/number_trivia_data_actions.dart';
import '../store/number_trivia_form/number_trivia_form_store.dart';

part 'number_trivia_form.widgets.dart';

const _borderRadius = BorderRadius.all(
  Radius.circular(10),
);

const InputDecoration _inputDecoration = InputDecoration(
  helperText: ' ',
  border: OutlineInputBorder(),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 1.5),
    borderRadius: _borderRadius,
  ),
);

typedef _DispatchAction = VoidCallback;

class NumberTriviaForm extends StatelessWidget {
  const NumberTriviaForm();

  @override
  Widget build(BuildContext context) {
    final store = AppStore.of(context);

    return Column(
      children: [
        ReduxTextField(
          valueObjectValidator: (value) => UnsignedInteger(value ?? ''),
          onChange: (number) {
            store.dispatch(
              NumberTriviaFormAction.numberChanged(UnsignedInteger(number)),
            );
          },
          stateValueAccess: (state) {
            return numberTriviaFormStateSelector(state)
                .params
                .number
                .value
                .fold(
                  (_) => '',
                  (number) => number.toString(),
                );
          },
          keyboardType: TextInputType.number,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: _inputDecoration.copyWith(
            labelText: 'Number',
          ),
          onComplete: () {
            final state = numberTriviaFormStateSelector(store.state);
            if (!state.params.number.isValid) {
              return;
            }

            store.dispatch(
              NumberTriviaDataAction.fetchConcrete(state.params),
            );
          },
        ),
        const Gap(10),
        const NumberTriviaFormButtons(),
      ],
    );
  }
}
