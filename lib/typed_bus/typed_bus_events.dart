//// TypedBusEvents manages registering event payloads types
class TypedBusEvents {
  //// Singleton instance
  static final TypedBusEvents _instance = TypedBusEvents._internal();

  //// Factory constructor for singleton access
  factory TypedBusEvents() => _instance;

  //// Private constructor
  TypedBusEvents._internal();

  //// Registry to map event names to their payload types
  final Map<String, Type> _registry = {};

  //// Register an event with its payload type
  void registerEvent<T>(String event) {
    if (_registry.containsKey(event)) {
      throw ArgumentError('Event "$event" is already registered.');
    }
    _registry[event] = T;
  }

  //// Get event type by registered event name
  Type? getEventType(String event) {
    return _registry[event];
  }

  //// Validate the type of a registered event
  void validateEvent<T>(String event) {
    final expectedType = _registry[event];
    if (expectedType == null) {
      throw ArgumentError('Event "$event" is not registered.');
    }
    if (expectedType != dynamic && expectedType != T) {
      throw ArgumentError(
          'Type mismatch for event "$event": Expected $expectedType, got $T.');
    }
  }
}
