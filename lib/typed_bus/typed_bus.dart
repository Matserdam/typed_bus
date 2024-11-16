import 'dart:async';

import 'package:typed_bus/typed_bus.dart';

//// TypedBus singleton
class TypedBus {
  //// Singleton instance
  static final TypedBus _instance = TypedBus._internal();

  //// Factory constructor for singleton access
  factory TypedBus() => _instance;

  //// Private constructor
  TypedBus._internal();

  //// Stream controllers for events
  final Map<String, StreamController<dynamic>> _controllers = {};

  //// Internal: Get or create a controller for an event
  StreamController<dynamic> _getController(String event) {
    if (!_controllers.containsKey(event)) {
      _controllers[event] = StreamController.broadcast();
    }
    return _controllers[event]!;
  }

  //// Publish an event with strict type checking
  void publish<T>(String event, T data) {
    tBE.validateEvent<T>(event);
    final controller = _getController(event);
    controller.add(data);
  }

  //// Publish an event with loose type checking (raw data)
  void wildFire(String event, dynamic data) {
    final controller = _getController(event);
    controller.add(data);
  }

  //// Subscribe to an event
  Stream<T> subscribe<T>(String event) {
    tBE.validateEvent<T>(event);
    return _getController(event).stream.cast<T>();
  }

  //// Subscribe without type casting (raw stream)
  Stream<dynamic> subscribeRaw(String event) {
    tBE.validateEvent<dynamic>(event);
    return _getController(event).stream;
  }

  //// Dispose all controllers
  void dispose() {
    _controllers.values.forEach((controller) => controller.close());
    _controllers.clear();
  }
}
