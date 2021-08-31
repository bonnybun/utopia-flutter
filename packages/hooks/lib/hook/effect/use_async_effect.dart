import 'package:utopia_hooks/hook/effect/use_simple_effect.dart';
import 'package:utopia_hooks/utopia_hooks.dart';

void useAsyncEffect(Future<void> Function() effect, [List<Object?>? keys]) {
  useSimpleEffect(
    () => Future.microtask(() async {
      try {
        await effect();
      } catch (e, s) {
        UtopiaHooks.reporter?.error('Error in useAsyncEffect', e, s);
      }
    }),
    keys,
  );
}
