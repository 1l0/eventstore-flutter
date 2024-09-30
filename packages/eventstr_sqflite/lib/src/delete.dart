import 'package:sqflite/sqflite.dart';
import 'package:nip01/nip01.dart';

Future<int> deleteEventImpl(DatabaseExecutor client, Event event) async {
  return await client.delete(
    'event',
    where: 'id = ?',
    whereArgs: [event.id],
  );
}
