import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:eventstore/eventstore.dart';
import 'package:nip01/nip01.dart';

class SqfliteBackend implements Store {
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

  @override
  void init() {
    // TODO:
  }

  @override
  static void ensureInitialized() {
    if (kIsWeb) {
      databaseFactoryOrNull = databaseFactoryFfiWeb;
    } else if (Platform.isLinux || Platform.isWindows) {
      sqfliteFfiInit();
      databaseFactoryOrNull = databaseFactoryFfi;
    }
  }

  @override
  void dispose() {
    // TODO: close db
  }
  @override
  Stream<Event> queryEvents(Filters filter) {
    // TODO:
    return Stream.empty();
  }

  @override
  deleteEvent(Event event) {
    // TODO:
  }

  @override
  saveEvent(Event event) {
    // TODO:
  }
}
