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
    final List<dynamic> decoded = jsonDecode(encoded);
    final List<List<String>> dec =
        decoded.map((value) => List<String>.from(value)).toList();
    print(dec);
  });
}
