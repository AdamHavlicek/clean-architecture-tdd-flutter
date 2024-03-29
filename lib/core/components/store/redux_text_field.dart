import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../domain/value_object.dart';
import '../../store/app_state.dart';
import '../../store/app_store.dart';
import '../stream_listener.dart';

typedef StateValueAccess<State> = String? Function(State state);
typedef ValueObjectValidator<T> = ValueObject<T> Function(String? value);

class ReduxTextField extends HookWidget {
  final TextInputType keyboardType;
  final bool obscureText;
  final bool focusNext;
  final bool clearOnTap;
  final StateValueAccess<AppState> stateValueAccess;
  final InputDecoration decoration;
  final ValueChanged<String> onChange;
  final TextAlign textAlign;
  final ValueObjectValidator<dynamic>? valueObjectValidator;
  final TextEditingController? controller;
  final Function? onComplete;
  final FocusNode? focusNode;
  final int? minLines;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final AutovalidateMode? autovalidateMode;

  final _formKey = GlobalKey<FormState>();

  ReduxTextField(
      {super.key,
      required this.onChange,
      required this.stateValueAccess,
      required this.decoration,
      this.controller,
      this.focusNode,
      this.onComplete,
      this.valueObjectValidator,
      this.minLines,
      this.maxLines,
      this.textInputAction,
      this.textAlign = TextAlign.start,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.focusNext = false,
      this.clearOnTap = false,
      this.autovalidateMode = AutovalidateMode.always});

  void _setInputValue(String? input, TextEditingController controller) {
    controller.text = input ?? '';
  }

  String? executeValidator(String? value) {
    return valueObjectValidator?.call(value).failure.fold(
          () => null,
          (failure) => failure.message,
        );
  }

  @override
  Widget build(BuildContext context) {
    final store = AppStore.of(context);
    final controller = this.controller ??
        useTextEditingController(
          text: stateValueAccess(store.state),
        );
    final focusNode = this.focusNode ?? useFocusNode();

    // Initial validation
    final errorText = useState(
      executeValidator(controller.text),
    )..value = null;

    return StreamListener<String?>(
      stream: store.onChange.map(stateValueAccess).distinct(),
      listener: (input) {
        if (!focusNode.hasFocus) {
          _setInputValue(input, controller);
        }

        errorText.value = null;
      },
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          focusNode: focusNode,
          minLines: minLines,
          textAlign: textAlign,
          maxLines: maxLines ?? 1,
          onChanged: onChange,
          validator: executeValidator,
          autovalidateMode: this.autovalidateMode,
          decoration: decoration.copyWith(errorText: errorText.value),
          onTap: () {
            if (clearOnTap) {
              onChange('');
              _setInputValue('', controller);
            }
          },
          textInputAction: () {
            if (maxLines != null && maxLines! > 1) {
              return TextInputAction.newline;
            } else if (focusNext) {
              return TextInputAction.next;
            } else if (textInputAction != null) {
              return textInputAction;
            }

            return TextInputAction.done;
          }(),
          onEditingComplete: () {
            onComplete?.call();

            if (focusNext) {
              focusNode.nextFocus();
            } else {
              focusNode.unfocus();
            }
          },
        ),
      ),
    );
  }
}
