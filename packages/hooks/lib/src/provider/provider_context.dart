abstract interface class ProviderContext {
  /// Special value returned by [ProviderContext.getUnsafe] when the requested value can't be provided.
  static const valueNotFound = Object();

  /// Retrieves the value of the requested [type] and optionally watches for its change.
  /// Returned values are guaranteed to be of type [type] or [valueNotFound] when it isn't found.
  /// {@template ProviderContext.watch}
  /// If [watch] is not set, implementation should perform an educated guess (e.g. based on whether it's called during
  /// a build).
  /// Exact meaning of "watching" depends on the implementation and may not be supported.
  /// {@endtemplate}
  dynamic getUnsafe(Type type, {bool? watch});
}

/// An exception thrown by [ProviderContextExtensions.get] when the requested value can't be provided.
class ProvidedValueNotFoundException implements Exception {
  final Type type;
  final ProviderContext context;

  const ProvidedValueNotFoundException({required this.type, required this.context});

  @override
  String toString() => "Provided value of type $type not found in $context";
}

extension ProviderContextExtensions on ProviderContext {
  /// Retrieves the value of the requested type [T] or throws [ProvidedValueNotFoundException] when it can't be provided.
  ///
  /// {@macro ProviderContext.watch}
  T get<T>({bool? watch}) {
    final value = getUnsafe(T, watch: watch);
    if (value == ProviderContext.valueNotFound) throw ProvidedValueNotFoundException(type: T, context: this);
    return value as T;
  }

  /// Retrieves the value of the requested type [T] or returns `null` when it can't be provided.
  ///
  /// {@macro ProviderContext.watch}
  T? getOrNull<T>({bool? watch}) {
    final value = getUnsafe(T, watch: watch);
    if(value == ProviderContext.valueNotFound) return null;
    return value as T;
  }
}
