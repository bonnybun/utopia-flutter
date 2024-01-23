import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:utopia_hooks/src/base/flutter/hook_widget.dart';
import 'package:utopia_hooks/src/hook/base/use_effect.dart';
import 'package:utopia_hooks/src/hook/base/use_memoized.dart';
import 'package:utopia_hooks/src/hook/base/use_value_wrapper.dart';
import 'package:utopia_utils/utopia_utils.dart';

class StatelessTextEditingControllerWrapper extends HookWidget {
  final MutableValue<String> text;
  final TextEditingController Function({String? text}) controllerProvider;
  final Widget Function(TextEditingController) builder;

  const StatelessTextEditingControllerWrapper({
    super.key,
    required this.text,
    this.controllerProvider = TextEditingController.new,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useMemoized(() => controllerProvider(text: text.value), [], (it) => it.dispose());

    final wrappedValue = useValueWrapper(text);
    useEffect(() {
      void listener() {
        if (controller.text != wrappedValue().value) text.value = controller.text;
      }

      controller.addListener(listener);
      return () {
        try {
          controller.removeListener(listener);
        } catch (_) {
          // ignore errors during dispose
        }
      };
    });

    useEffect(() {
      if (controller.text != text.value) {
        Timer.run(() => controller.text = text.value);
      }
      return null;
    }, [text.value]);

    return builder(controller);
  }
}
