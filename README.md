
# **TypedBus (TB) and TypedBusEvents (TBE)**

TypedBus (`TB`) and TypedBusEvents (`TBE`) provide a powerful, type-safe event bus for Dart applications. With TypedBus, you can publish and subscribe to strongly-typed events, ensuring safe communication between different parts of your application.

This library offers compile-time and runtime safety, allowing developers to write clean and predictable event-driven code.

---

## **Features**

- **Type-Safe Event Handling**: Events are tied to specific data types, ensuring only valid payloads are passed.
- **Dynamic Event Registration**: Register new events and their types dynamically using `TBE`.
- **Subscription Management**: Subscribe to events and listen to typed data.
- **Publish Events**: Publish strongly-typed events globally.
- **Error Handling**: Protects against mismatched event types during publishing and subscribing.

---

## **Installation**

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  typed_bus: ^1.0.0
```

Then fetch the package:

```bash
flutter pub get
```

---

## **Getting Started**

### **1. Register Events**

Before publishing or subscribing, register events and their expected payload types using `TBE.registerEvent`:

```dart
TBE.registerEvent<String>('event1');
```

### **2. Subscribe to Events**

Use `TB.subscribe` to listen for specific events. Subscribers receive only the payloads of the registered type:

```dart
TB.subscribe<String>('event1').listen((String data) {
  print('Received Event 1: $data');
});
```

### **3. Publish Events**

Use `TB.publish<T>` to send events globally with their corresponding payloads:

```dart
TB.publish<String>('event1', "Hello world!"); 
```

### **4. Error Handling**

If you attempt to publish or subscribe with mismatched types, the library will throw a runtime exception. Be cautious with types, especially when using generics like `Map`.

#### **Example of a Mismatched Type**
```dart
TB.publish<String>('action3', SomethingCrazy(
  options: {},
  option1: true,
  option2: false,
  option3: true,
  option4: false,
));
// Throws an exception: Type mismatch
```

---

## **API Reference**

### **TypedBusEvents (TBE)**

#### **Register an Event**
```dart
TBE.registerEvent<T>(String event);
```
- Registers a new event with the specified payload type `<T>`.

#### **Example**
```dart
TBE.registerEvent<String>('my_event');
```

---

### **TypedBus (TB)**

#### **Subscribe to an Event**
```dart
Stream<T> TB.subscribe<T>(String event);
```
- Subscribes to an event and listens for payloads of type `<T>`.

#### **Publish an Event**
```dart
void TB.publish<T>(String event, T data);
```
- Publishes an event globally with the given payload.

---

## **Example Usage**

```dart
import 'package:typed_bus/typed_bus.dart';


void main() {
  // Register events
  TBE.registerEvent<String>('eventName');

  // Subscribe to events
  TB.subscribe<String>('eventName').listen((data) {
    print('Received eventName: $data');
  });

  TB.publish<String>('eventName', 'Hello world!');  
}
```

---

## **Advanced Usage**

### **Custom Types**

For events with a custom type, just use it. 

#### Define your custom type
```dart
class TodoItem {
  String description;
  bool isDone;

  TodoItem({required this.description, required this.isDone});

  @override
  String toString() {
    return 'TodoItem(description: $description, isDone: $isDone)';
  }
}
```

#### Use your custom type
```dart

TBE.registerEvent<TodoItem>("toggle");

TB.subscribe<TodoItem>('toggle').listen((TodoItem item) {
  // do something with the item
  toggleItem(item);
});

TB.publish<TodoItem>(
    'toggle', TodoItem(description: "Publish Toggle Event", isDone: false));
```


### **Dynamic Payloads**

For events where the payload type isn’t fixed, you can use `dynamic`:

```dart
TBE.registerEvent<dynamic>('dynamic_event');

TB.subscribe<dynamic>('dynamic_event').listen((data) {
  print('Dynamic event received: $data');
});

TB.publish<dynamic>('dynamic_event', {'key': 'value'});
TB.publish<dynamic>('dynamic_event', 12345);
```

---

## Licensing

This project is available under two licenses:

### **1. MIT License (Open Source)**
The open-source version of this project is licensed under the permissive MIT License. You are free to:
- Use the code for personal or commercial purposes.
- Modify, distribute, and integrate it into your projects.

However, this version comes **as is** with no support, warranties, or guarantees.

View the full MIT License [here](LICENSE).

---

### **2. Commercial License**
For organizations and enterprises requiring additional rights or support, a Commercial License is available. It includes:
- Priority support and feature requests.
- Indemnification and compliance with corporate legal policies.
- Permission to use the software without attribution (if applicable).

To purchase a Commercial License or learn more, please contact us at mats@matsdeswart.nl.

---

### **Which License Should You Choose?**
- If you’re an individual or small team using the software in an open-source or non-critical project, the **MIT License** is sufficient.
- If you need priority support, legal assurances, or customized terms, opt for the **Commercial License**.

## **Conclusion**

TypedBus and TypedBusEvents provide a robust way to handle event-driven communication in Dart applications. The library’s focus on type safety ensures your events are predictable and easy to debug.

For questions or contributions, feel free to open an issue or create a pull request!
