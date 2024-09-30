import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:nip01/nip01.dart';

Future<void> saveEventImpl(DatabaseExecutor client, Event event) async {
  if (client is Database) {
    final values = <String, Object?>{
      'id': event.id,
      'pubkey': event.pubkey,
      'created_at': event.createdAt,
      'kind': event.kind,
      'content': event.content,
      'tags': jsonEncode(event.tags),
      'sig': event.sig,
    };
    await client.transaction((txn) async {
      await txn.insert('event', values);
    });
  }
}
