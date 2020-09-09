import 'package:flutter/widgets.dart';
import 'mixins.dart';

/// A [ValueNotifier] with [ValueStream].
class ValueStreamNotifier<T> = ValueNotifier<T> with ValueStream<T>;

/// A [TextEditingController] with [ValueStream].
class TextEditingStreamController = TextEditingController
    with ValueStream<TextEditingValue>;

/// A [ClipboardStatusNotifier] with [ValueStream].
class ClipboardStatusStreamNotifier = ClipboardStatusNotifier
    with ValueStream<ClipboardStatus>;

/// A [TransformationController] with [ValueStream].
class TransformationStreamController = TransformationController
    with ValueStream<Matrix4>;
