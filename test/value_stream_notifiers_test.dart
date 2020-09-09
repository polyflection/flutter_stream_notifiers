import 'package:flutter/widgets.dart';
import 'package:flutter_stream_notifiers/flutter_stream_notifiers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Notifiers with ValueStream', () {
    setUp(() {
      WidgetsFlutterBinding.ensureInitialized();
    });

    group(ValueStreamNotifier, () {
      test('is $ValueStream.', () {
        expect(ValueStreamNotifier<int>(0) is ValueStream<int>, isTrue);
      });
    });

    group(TextEditingStreamController, () {
      test('is $ValueStream.', () {
        expect(
            TextEditingStreamController(text: 'a')
                is ValueStream<TextEditingValue>,
            isTrue);
      });
    });

    group(ClipboardStatusStreamNotifier, () {
      test('is $ValueStream.', () {
        expect(
            ClipboardStatusStreamNotifier(value: ClipboardStatus.pasteable)
                is ValueStream<ClipboardStatus>,
            isTrue);
      });
    });

    group(TransformationStreamController, () {
      test('is $ValueStream.', () {
        expect(
            TransformationStreamController(Matrix4.zero())
                is ValueStream<Matrix4>,
            isTrue);
      });
    });
  });
}
