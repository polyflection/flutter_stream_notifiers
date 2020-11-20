import 'package:flutter/foundation.dart';
import 'package:flutter_stream_notifiers/flutter_stream_notifiers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(ValueStream, () {
    _DerivedValueNotifier? target;

    setUp(() {
      target = _DerivedValueNotifier(0);
    });

    test('A latest value is delivered on listen immediately.', () async {
      final emits = [];
      target!.stream.listen((e) => emits.add(e));
      await pumpEventQueue();
      expect(emits, orderedEquals([0]));
    });

    test('Stream on a value changes.', () async {
      final emits = [];
      target!.stream.listen((e) => emits.add(e));
      target!
        ..value = 1
        ..value = 2
        ..value = 3;
      await pumpEventQueue();
      expect(emits, orderedEquals([0, 1, 2, 3]));
    });

    test('Multiple Stream listeners.', () async {
      final emits1 = [];
      final subscription1 = target!.stream.listen((e) => emits1.add(e));
      final emits2 = [];
      final subscription2 = target!.stream.listen((e) => emits2.add(e));

      target!
        ..value = 1
        ..value = 2
        ..value = 3;

      await pumpEventQueue();
      await subscription1.cancel();

      target!
        ..value = 4
        ..value = 5
        ..value = 6;

      await pumpEventQueue();
      await subscription2.cancel();

      expect(emits1, orderedEquals([0, 1, 2, 3]));
      expect(emits2, orderedEquals([0, 1, 2, 3, 4, 5, 6]));

      target!.value = 7;
      await pumpEventQueue();

      expect(emits1, orderedEquals([0, 1, 2, 3]));
      expect(emits2, orderedEquals([0, 1, 2, 3, 4, 5, 6]));
    });

    test('All streams are closed on dispose.', () async {
      var isOnDoneCalled1 = false;
      var isOnDoneCalled2 = false;
      target!.stream.listen(null, onDone: () {
        isOnDoneCalled1 = true;
      });
      target!.stream.listen(null, onDone: () {
        isOnDoneCalled2 = true;
      });
      await target!.dispose();
      expect(isOnDoneCalled1, isTrue);
      expect(isOnDoneCalled2, isTrue);
    });

    test(
        'An internal stream controllers is null on dispose, and never be changed.',
        () async {
      target!.stream.listen(null);
      await target!.dispose();
      expect(target!.controllers, isEmpty);
      target!.stream.listen(null);
      expect(target!.controllers, isEmpty);
    });

    test('After the disposing, a new Stream is closed immediately.', () async {
      await target!.dispose();

      final emits = [];
      var isOnDoneCalled = false;
      target!.stream.listen((e) => emits.add(e), onDone: () {
        isOnDoneCalled = true;
      });
      expect(target!.controllers, isEmpty);
      await pumpEventQueue();
      expect(emits, isEmpty);
      expect(isOnDoneCalled, isTrue);
    });

    test(
        'Apply to a derived ValueNotifier that overrides return Type of dispose() with Future<void>',
        () async {
      final target = _FutureDisposingValueStreamNotifier<int>(0);
      expect(target.dispose() is Future<void>, isTrue);
    });
  });

  group(ChangeNotifierStream, () {
    _DerivedChangeStreamNotifier? target;

    setUp(() {
      target = _DerivedChangeStreamNotifier(0);
    });

    test(
        'A derived object itself from ChangeNotifier is delivered on listen immediately.',
        () async {
      final emits = [];
      target!.stream.listen((e) => emits.add(e));
      await pumpEventQueue();
      expect(emits, orderedEquals([target]));
    });

    group('Synchronous adding to a Stream and asynchronous delivering.', () {
      test(
          ' Adding a derived object to stream controller synchronously,'
          ' however, the values have already been incremented'
          ' when the derived objects are delivered asynchronously.', () async {
        final emits = [];
        final values = [];
        target!.stream.listen((e) {
          emits.add(e);
          values.add(e.i);
        });
        target!..increment()..increment()..increment();
        await pumpEventQueue();
        expect(emits, orderedEquals([target, target, target, target]));
        expect(values, orderedEquals([3, 3, 3, 3]));
      });

      test('Waiting for the derived objects are delivered asynchronously.',
          () async {
        final emits = [];
        final values = [];
        target!.stream.listen((e) {
          emits.add(e);
          values.add(e.i);
        });
        await pumpEventQueue();
        target!.increment();
        await pumpEventQueue();
        target!.increment();
        await pumpEventQueue();
        target!.increment();
        await pumpEventQueue();
        expect(emits, orderedEquals([target, target, target, target]));
        expect(values, orderedEquals([0, 1, 2, 3]));
      });
    });

    test('Multiple Stream listeners.', () async {
      final emits1 = [];
      final subscription1 = target!.stream.listen((e) => emits1.add(e.i));
      final emits2 = [];
      final subscription2 = target!.stream.listen((e) => emits2.add(e.i));

      await pumpEventQueue();
      target!..increment()..increment()..increment();

      await pumpEventQueue();
      await subscription1.cancel();

      target!..increment()..increment()..increment();

      await pumpEventQueue();
      await subscription2.cancel();

      expect(emits1, orderedEquals([0, 3, 3, 3]));
      expect(emits2, orderedEquals([0, 3, 3, 3, 6, 6, 6]));

      target!.increment();
      await pumpEventQueue();

      expect(emits1, orderedEquals([0, 3, 3, 3]));
      expect(emits2, orderedEquals([0, 3, 3, 3, 6, 6, 6]));
    });

    test('All streams are closed on dispose.', () async {
      var isOnDoneCalled1 = false;
      var isOnDoneCalled2 = false;
      target!.stream.listen(null, onDone: () {
        isOnDoneCalled1 = true;
      });
      target!.stream.listen(null, onDone: () {
        isOnDoneCalled2 = true;
      });
      await target!.dispose();
      expect(isOnDoneCalled1, isTrue);
      expect(isOnDoneCalled2, isTrue);
    });

    test(
        'An internal stream controllers is null on dispose, and never be changed.',
        () async {
      target!.stream.listen(null);
      await target!.dispose();
      expect(target!.controllers, isEmpty);
      target!.stream.listen(null);
      expect(target!.controllers, isEmpty);
    });

    test('After disposing, a new Stream is closed immediately.', () async {
      await target!.dispose();

      final emits = [];
      var isOnDoneCalled = false;
      target!.stream.listen((e) => emits.add(e.i), onDone: () {
        isOnDoneCalled = true;
      });
      expect(target!.controllers, isEmpty);
      await pumpEventQueue();
      expect(emits, isEmpty);
      expect(isOnDoneCalled, isTrue);
    });

    test(
        'Apply to a derived ChangeNotifier that overrides return Type of dispose() with Future<void>',
        () async {
      final target = _FutureDisposingChangeStreamNotifier(0);
      expect(target.dispose() is Future<void>, isTrue);
    });
  });
}

class _DerivedValueNotifier<T> = ValueNotifier<T> with ValueStream<T>;

class _DerivedChangeStreamNotifier
    extends ChangeStreamNotifier<_DerivedChangeStreamNotifier> {
  _DerivedChangeStreamNotifier(this._i);
  int _i;
  int get i => _i;
  void increment() {
    _i++;
    notifyListeners();
  }
}

class _FutureDisposingValueNotifier<T> extends ValueNotifier<T> {
  _FutureDisposingValueNotifier(T value) : super(value);
  @override
  Future<void> dispose() {
    super.dispose();
    return Future.value();
  }
}

class _FutureDisposingValueStreamNotifier<T> = _FutureDisposingValueNotifier<T>
    with ValueStream<T>;

class _FutureDisposingChangeNotifier extends ChangeNotifier {
  @override
  Future<void> dispose() {
    super.dispose();
    return Future.value();
  }
}

class _FutureDisposingChangeStreamNotifier
    extends ChangeStreamNotifier<_FutureDisposingChangeNotifier> {
  _FutureDisposingChangeStreamNotifier(this._i);
  int _i;
  int get i => _i;
  void increment() {
    _i++;
    notifyListeners();
  }
}
