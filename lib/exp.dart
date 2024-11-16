import 'package:typed_bus/typed_bus.dart';

class TodoItem {
  String description;
  bool isDone;

  TodoItem({required this.description, required this.isDone});

  @override
  String toString() {
    return 'TodoItem(description: $description, isDone: $isDone)';
  }
}

void main() {
  TBE.registerEvent<TodoItem>("toggle");

  TB.subscribe<TodoItem>('toggle').listen((TodoItem item) {
    // do something with the item
    item.isDone = true;

    print(item);
  });

  TB.publish<TodoItem>(
      'toggle', TodoItem(description: "Publish Toggle Event", isDone: false));

  // Typed publishing
}
