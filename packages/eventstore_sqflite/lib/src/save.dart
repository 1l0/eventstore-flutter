import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:nip01/nip01.dart';

Future<void> saveEventImpl(DatabaseExecutor client, Event event) async {
  final values = <String, Object?>{
    'id': event.id,
    'pubkey': event.pubkey,
    'created_at': event.createdAt,
    'kind': event.kind,
    'content': event.content,
    'tags': jsonEncode(event.tags), // TODO:
    'sig': event.sig,
  };
  final db = client as Database;
  await db.transaction((txn) async {
    if (await txn.update(
          'event',
          values,
          where: 'id = ?',
          whereArgs: [event.id],
        ) ==
        0) {
      await txn.insert('event', values);
    }
  });
}
