import 'package:flutter/widgets.dart';
import 'package:flutter_stream_notifiers/flutter_stream_notifiers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Notifiers with ChangeNotifierStream', () {
    setUp(() {
      WidgetsFlutterBinding.ensureInitialized();
    });

    group(ChangeStreamNotifier, () {
      test('is $ChangeNotifierStream.', () {
        expect(_DerivedChangeStreamNotifier() is ChangeNotifierStream, isTrue);
      });
    });

    group(ScrollStreamController, () {
      test('is $ChangeNotifierStream.', () {
        expect(
            ScrollStreamController(initialScrollOffset: 0)
                is ChangeNotifierStream,
            isTrue);
      });
    });

    group(FocusStreamNode, () {
      test('is $ChangeNotifierStream.', () {
        expect(FocusStreamNode() is ChangeNotifierStream, isTrue);
      });
    });

    group(FocusStreamManager, () {
      test('is $ChangeNotifierStream.', () {
        expect(FocusStreamManager() is ChangeNotifierStream, isTrue);
      });
    });

    group(PageStreamController, () {
      test('is $ChangeNotifierStream.', () {
        expect(PageStreamController() is ChangeNotifierStream, isTrue);
      });
    });
  });
}

class _DerivedChangeStreamNotifier extends ChangeStreamNotifier {}
