import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/utils/utils.dart';
import 'package:nip01/nip01.dart';

Stream<Event> queryEventsImpl(DatabaseExecutor client, Filters filter) async* {
  yield const Event(
      pubkey: 'pubkey', createdAt: 1, kind: 1, content: 'content');
}
