import 'package:typed_bus/typed_bus.dart';

class Action1Payload {
  final String actionName;
  final int count;

  Action1Payload(this.actionName, this.count);
}

class Action2Payload {
  final String message;

  Action2Payload(this.message);
}

void main() {
  TBE.registerEvent<Action1Payload>('action1');
  TBE.registerEvent<Action2Payload>('action2');

  TB.subscribe<Action1Payload>('action1').listen((data) {
    print('Received Action1: ${data.actionName}, count: ${data.count}');
  });

  TB.subscribe<Action2Payload>('action2').listen((data) {
    print('Received Action1: ${data.message}');
  });

  TB.emit("action1", Action1Payload("TestAction", 1));
  TB.publish<Action1Payload>("action1", Action1Payload("test", 2));
}
