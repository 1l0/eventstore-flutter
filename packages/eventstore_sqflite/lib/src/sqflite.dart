import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:eventstore/eventstore.dart';
import 'package:nip01/nip01.dart';

class SqfliteBackend implements Store {
  SqfliteBackend({
    required this.path,
    this.queryLimit = 100,
    this.queryIDsLimit = 500,
    this.queryAuthorsLimit = 500,
    this.queryKindsLimit = 10,
    this.queryTagsLimit = 10,
  });

  final String path;

  final int queryLimit;
  final int queryIDsLimit;
  final int queryAuthorsLimit;
  final int queryKindsLimit;
  final int queryTagsLimit;

  late final Future<Database> _db = () async {
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''CREATE TABLE IF NOT EXISTS event (
id text NOT NULL,
pubkey text NOT NULL,
created_at integer NOT NULL,
kind integer NOT NULL,
tags jsonb NOT NULL,
content text NOT NULL,
sig text NOT NULL);
CREATE UNIQUE INDEX IF NOT EXISTS ididx ON event(id)
CREATE INDEX IF NOT EXISTS pubkeyprefix ON event(pubkey)
CREATE INDEX IF NOT EXISTS timeidx ON event(created_at DESC)
CREATE INDEX IF NOT EXISTS kindidx ON event(kind)
CREATE INDEX IF NOT EXISTS kindtimeidx ON event(kind,created_at DESC)''');
    });
  }();

  @override
  void init() {
    if (kIsWeb) {
      databaseFactoryOrNull = databaseFactoryFfiWeb;
    } else if (Platform.isLinux || Platform.isWindows) {
      sqfliteFfiInit();
      databaseFactoryOrNull = databaseFactoryFfi;
    }
  }

  @override
  void close() async {
    var db = await _db;
    if (db.isOpen) {
      await db.close();
    }
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
