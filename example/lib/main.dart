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
  tBE.registerEvent<TodoItem>("toggle");

  tB.subscribe<TodoItem>('toggle').listen((TodoItem item) {
    item.isDone = true;

    print(item);
  });

  tB.publish<TodoItem>(
      'toggle', TodoItem(description: "Publish Toggle Event", isDone: false));
}
