import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class SqfliteBackend {
  SqfliteBackend({
    this.queryLimit = 100,
    this.queryIDsLimit = 500,
    this.queryAuthorsLimit = 500,
    this.queryKindsLimit = 10,
    this.queryTagsLimit = 10,
  });

  final int queryLimit;
  final int queryIDsLimit;
  final int queryAuthorsLimit;
  final int queryKindsLimit;
  final int queryTagsLimit;

  static void ensureInitialized() {
    if (kIsWeb) {
      databaseFactoryOrNull = databaseFactoryFfiWeb;
    } else if (Platform.isLinux || Platform.isWindows) {
      sqfliteFfiInit();
      databaseFactoryOrNull = databaseFactoryFfi;
    }
  }

  void close() {
    // TODO: close db
  }
}
