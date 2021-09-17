import 'package:equatable/equatable.dart';

abstract class ComputedStateValue<T> {
  const ComputedStateValue._();

  static const ComputedStateValue<Never> notInitialized = ComputedStateValueNotInitialized._();

  const factory ComputedStateValue.inProgress(Future<T> future) = ComputedStateValueInProgress._;

  const factory ComputedStateValue.ready(T value) = ComputedStateValueReady._;

  const factory ComputedStateValue.failed(Object exception) = ComputedStateValueFailed._;

  R maybeWhen<R>({
    R Function()? notInitialized,
    R Function(Future<T> future)? inProgress,
    R Function(T value)? ready,
    R Function(Object exception)? failed,
    required R Function() orElse,
  }) {
    final value = this;
    if (value is ComputedStateValueNotInitialized && notInitialized != null) return notInitialized();
    if (value is ComputedStateValueInProgress<T> && inProgress != null) return inProgress(value.future);
    if (value is ComputedStateValueReady<T> && ready != null) return ready(value.value);
    if (value is ComputedStateValueFailed && failed != null) return failed(value.exception);
    return orElse();
  }

  R when<R>({
    required R Function() notInitialized,
    required R Function(Future<T> future) inProgress,
    required R Function(T value) ready,
    required R Function(Object exception) failed,
  }) {
    return maybeWhen(
      notInitialized: notInitialized,
      inProgress: inProgress,
      ready: ready,
      failed: failed,
      orElse: () {
        throw StateError('Invalid ComputedStateValue descendant');
      },
    );
  }

  T? get valueOrNull => maybeWhen(ready: (value) => value, orElse: () => null);

  ComputedStateValue<R> mapValue<R>(R Function(T) block) {
    return when(
      notInitialized: () => ComputedStateValue.notInitialized,
      inProgress: (future) => ComputedStateValue.inProgress(future.then((value) => block(value))),
      ready: (value) => ComputedStateValue.ready(block(value)),
      failed: (exception) => ComputedStateValue.failed(exception),
    );
  }
}

class ComputedStateValueNotInitialized extends ComputedStateValue<Never> with EquatableMixin {
  const ComputedStateValueNotInitialized._() : super._();

  @override
  get props => [];
}

class ComputedStateValueInProgress<T> extends ComputedStateValue<T> with EquatableMixin {
  final Future<T> future;

  const ComputedStateValueInProgress._(this.future) : super._();

  @override
  get props => [future];
}

class ComputedStateValueReady<T> extends ComputedStateValue<T> with EquatableMixin {
  final T value;

  const ComputedStateValueReady._(this.value) : super._();

  @override
  get props => [value];
}

class ComputedStateValueFailed extends ComputedStateValue<Never> with EquatableMixin {
  final Object exception;

  const ComputedStateValueFailed._(this.exception) : super._();

  @override
  get props => [exception];
}
