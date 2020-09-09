# flutter_stream_notifiers

Provides a bunch of special notifiers derived from Flutter's ValueNotifier or ChangeNotifier, that additionally streams a value or notifier itself on a change notification.

```dart
// TextEditingStreamController is a sub class of TextEditingController,
// that is a sub class of ValueNotifier.
final controller = TextEditingStreamController(text: 'a');
controller.stream.listen((TextEditingValue value) {
  print(value.text); // prints a, b, c.
});
controller..text = 'b'..text = 'c';
```

# Available notifiers

- `ValueStream` streams a value on a change notification. It is for a sub class of `ValueNotifier`.
- `ChangeNotifierStream` streams a notifier itself on a change notification. It is for a sub class of `ChangeNotifier`.

## With `ValueStream`

| Sub class with ValueStream     | Super class              |
| ------------------------------ | ------------------------ |
| ValueStreamNotifier            | ValueNotifier            |
| TextEditingStreamController    | TextEditingController    |
| ClipboardStatusStreamNotifier  | ClipboardStatusNotifier  |
| TransformationStreamController | TransformationController |

## With `ChangeNotifierStream`

| Sub class with ChangeNotifierStream | Super class      |
| ----------------------------------- | ---------------- |
| ChangeStreamNotifier                | ChangeNotifier   |
| ScrollStreamController              | ScrollController |
| FocusStreamNode                     | FocusNode        |
| FocusStreamManager                  | FocusManager     |
| PageStreamController                | PageController   |

---

This package will eventually provide most of the classes corresponding to kinds of ChangeNotifier or ValueNotifier in Flutter framework.

### Current Status

(Flutter version 1.21.0).
Providing stream notifiers corresponding to classes of:

- ValueNotifier: completed
- ChangeNotifier: NOT completed

## Extending third party packages.

For keeping this package's dependency as minimum as possible, this package will only provide the notifiers whose super classes are available in Flutter framework.

For a third party package that has a class derived from ValueNotifier or ChangeNotifier, one can create a notifier from them with `ValueStream` or `ChangeNotifierStream`.

It should be fairly easy since it's just about applying corresponding mixin.

```dart
class DerivedValueStreamNotifier<T> = DerivedValueNotifier<T> with ValueStream<T>;
```

The examples from this package's implementation.

```dart
/// A [TextEditingController] with [ValueStream].
class TextEditingStreamController = TextEditingController
    with ValueStream<TextEditingValue>;
```

```dart
/// A [ScrollController] with [ChangeNotifierStream].
class ScrollStreamController = ScrollController
    with ChangeNotifierStream<ScrollController>;
```

# Features

## All constructors are derived from a super class

```dart
// TextEditingStreamController is a TextEditingController with ValueStream mixin.
// It derives all constructors from TextEditingController.
final controller = TextEditingStreamController(text: 'a');
```

## A latest value will be delivered on listen immediately

Unlike `addListener`, a latest value is delivered on listen.

```dart
final controller = TextEditingStreamController(text: 'a');
controller.stream.listen(print); // prints a, b.
controller.addListener(() {
  print(controller.text); // prints b.
})
controller.text = 'b';
```

## Internally, `addListener` on listening a stream, `removeListener` on canceling a stream subscription

```dart
final controller = TextEditingStreamController(text: 'a');
final subscription = controller.stream.listen(print); // addListener() internally.
subscription.cancel(); // removeListener internally.
```

## Multiple listeners are allowed

```dart
final controller = TextEditingStreamController(text: 'a');
controller.stream.listen(print); // prints a.
controller.stream.listen(print); // prints a.
```

This package leverages `MultiStream` supported at Dart 2.9.

## With ChangeNotifierStream, a notifier itself will be delivered

```dart
class DerivedChangeStreamNotifier
    extends ChangeStreamNotifier<DerivedChangeStreamNotifier> {
  DerivedChangeStreamNotifier(this._count);

  int _count;
  int get count => _count;
  void increment() {
    _count++;
    notifyListeners();
  }
}

notifier = DerivedChangeStreamNotifier(0);
notifier.stream.listen((notifier) {
  print(notifier.count); // prints 0, 1.
  print(notifier is DerivedChangeStreamNotifier) // prints true, true.
}); 
notifier.increment();
```

## All streams are closed on dispose

```dart
final controller = TextEditingStreamController(text: 'a');
controller.stream.listen(null, onDone: () {
  prints('done!'); // prints done!.
});
controller.dispose();
```

A new Stream of a notifier that has been disposed of, is closed immediately

```dart
final controller = TextEditingStreamController(text: 'a');
controller.dispose();
controller.stream.listen(null, onDone: () {
  prints('done!'); // prints done!.
});
```

No runtime FlutterError occurs when listening a stream of a notifier that has been disposed of.

## Features and bugs

Please file feature requests and bugs at the [issue tracker](https://github.com/polyflection/flutter_stream_notifiers/issues).
