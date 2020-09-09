import 'package:flutter/widgets.dart';
import 'mixins.dart';

/// A [ChangeNotifier] with [ChangeNotifierStream].
abstract class ChangeStreamNotifier<T extends ChangeNotifier> = ChangeNotifier
    with ChangeNotifierStream<T>;

/// A [ScrollController] with [ChangeNotifierStream].
class ScrollStreamController = ScrollController
    with ChangeNotifierStream<ScrollController>;

/// A [FocusNode] with [ChangeNotifierStream].
class FocusStreamNode = FocusNode with ChangeNotifierStream<FocusNode>;

/// A [FocusManager] with [ChangeNotifierStream].
class FocusStreamManager = FocusManager with ChangeNotifierStream<FocusManager>;

/// A [PageController] with [ChangeNotifierStream].
class PageStreamController = PageController
    with ChangeNotifierStream<PageController>;
