import 'dart:async';

import 'package:test/test.dart';
import 'package:typed_bus/typed_bus.dart';

void main() {
  group('TypedBusEvents', () {
    setUp(() {
      // Ensure fresh registry by recreating globals across tests
      tB.dispose();
    });

    test('registers and validates event type', () {
      tBE.registerEvent<String>('evt');
      expect(tBE.getEventType('evt'), equals(String));
      expect(() => tBE.validateEvent<String>('evt'), returnsNormally);
    });

    test('throws on duplicate event registration', () {
      tBE.registerEvent<int>('dup');
      expect(() => tBE.registerEvent<int>('dup'), throwsA(isA<ArgumentError>()));
    });

    test('throws on unregistered event validate', () {
      expect(() => tBE.validateEvent<String>('missing'), throwsA(isA<ArgumentError>()));
    });

    test('allows dynamic payloads', () {
      tBE.registerEvent<dynamic>('dyn');
      // Should not throw for different types
      expect(() => tBE.validateEvent<int>('dyn'), returnsNormally);
      expect(() => tBE.validateEvent<Map>('dyn'), returnsNormally);
    });
  });

  group('TypedBus', () {
    setUp(() {
      tB.dispose();
    });

    test('publish/subscribe delivers typed payload', () async {
      tBE.registerEvent<String>('greet');
      final List<String> received = [];
      final sub = tB.subscribe<String>('greet').listen(received.add);

      tB.publish<String>('greet', 'hello');
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(received, equals(['hello']));
      await sub.cancel();
    });

    test('publish throws on type mismatch', () {
      tBE.registerEvent<String>('strict');
      expect(() => tB.publish<int>('strict', 42), throwsA(isA<ArgumentError>()));
    });

    test('subscribe throws on type mismatch', () {
      tBE.registerEvent<int>('num');
      expect(() => tB.subscribe<String>('num'), throwsA(isA<ArgumentError>()));
    });

    test('wildFire bypasses type validation and delivers raw data', () async {
      tBE.registerEvent<dynamic>('raw');
      final List<dynamic> received = [];
      final sub = tB.subscribeRaw('raw').listen(received.add);

      tB.wildFire('raw', {'a': 1});
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(received.single, equals({'a': 1}));
      await sub.cancel();
    });

    test('dispose closes controllers and clears registry map', () async {
      tBE.registerEvent<String>('e1');
      final sub = tB.subscribe<String>('e1').listen((_) {});
      tB.dispose();
      await sub.cancel();
      // After dispose, re-register and reuse should work
      tBE.registerEvent<String>('e2');
      final s = tB.subscribe<String>('e2');
      expect(s, isA<Stream<String>>());
    });
  });
}


