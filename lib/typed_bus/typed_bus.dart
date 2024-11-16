import 'dart:async';

import 'package:typed_bus/typed_bus.dart';

class TypedBus {
  // Singleton instance
  static final TypedBus _instance = TypedBus._internal();

  // Factory constructor for singleton access
  factory TypedBus() => _instance;

  // Private constructor
  TypedBus._internal();

  // Stream controllers for events
  final Map<String, StreamController<dynamic>> _controllers = {};

  // Internal: Get or create a controller for an event
  StreamController<dynamic> _getController(String event) {
    if (!_controllers.containsKey(event)) {
      _controllers[event] = StreamController.broadcast();
    }
    return _controllers[event]!;
  }

  // Publish an event with strict type checking
  void publish<T>(String event, T data) {
    TBE.validateEvent<T>(event);
    final controller = _getController(event);
    controller.add(data);
  }

  void emit(String event, dynamic data) {
    final expectedType = TBE.getEventType(event);

    if (expectedType == null) {
      throw ArgumentError('Event "$event" is not registered.');
    }

    if (data.runtimeType != expectedType) {
      throw ArgumentError(
          'Type mismatch for event "$event": Expected $expectedType, got ${data.runtimeType}.');
    }

    // not using publish because of T requirement
    final controller = _getController(event);
    controller.add(data);
  }

  // Subscribe to an event
  Stream<T> subscribe<T>(String event) {
    TBE.validateEvent<T>(event);
    return _getController(event).stream.cast<T>();
  }

  // Subscribe without type casting (raw stream)
  Stream<dynamic> subscribeRaw(String event) {
    TBE.validateEvent<dynamic>(event);
    return _getController(event).stream;
  }

  // Dispose all controllers
  void dispose() {
    _controllers.values.forEach((controller) => controller.close());
    _controllers.clear();
  }
}
