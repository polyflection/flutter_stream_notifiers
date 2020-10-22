## 0.2.0

- Breaking: changes ValueStream's and ChangeNotifierStream's return type of dispose() to "Future<void>", for applying them to a class that extends ValueNotifier or ChangeNotifier with overriding a return type of dispose() to "Future<void>".

## 0.1.1

- Fix unnecessary exports.
- Fix typo.

## 0.1.0

- Initial version.
