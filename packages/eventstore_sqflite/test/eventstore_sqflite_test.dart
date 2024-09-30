import 'package:flutter_test/flutter_test.dart';

import 'dart:convert';

// import 'package:eventstore_sqflite/eventstore_sqflite.dart';

void main() {
  test('TODO: add test', () {});

  test('json', () {
    final list = <List<String>>[
      ["key1", "val1-1", "val1-2"],
      ["key2", "val2-1", "val2-2"],
    ];
    final encoded = jsonEncode(list);
    print(encoded);
    final decoded = jsonDecode(encoded);
    print(decoded);
    final dec = List.from(decoded);
    print(dec);
  });
}
