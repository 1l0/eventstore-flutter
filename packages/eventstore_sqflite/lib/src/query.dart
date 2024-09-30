import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:nip01/nip01.dart';

Stream<Event> queryEventsImpl(DatabaseExecutor client, Filters filters) async* {
  final sql = _buildSql(filters, false);
  final cursor = await client.rawQueryCursor(sql.sql, sql.arguments);
  try {
    while (await cursor.moveNext()) {
      final current = cursor.current;
      final tagsJson = current["tags"] as String;
      final List<List<String>> tags = jsonDecode(tagsJson)
          .map((value) => List<String>.from(
                value,
                growable: false,
              ))
          .toList();
      yield Event(
        id: current['id'] as String?,
        pubkey: current['pubkey'] as String,
        createdAt: current['created_at'] as int,
        kind: current['kind'] as int,
        tags: tags,
        content: current['content'] as String,
        sig: current['sig'] as String?,
      );
    }
  } finally {
    cursor.close();
  }
}

({String sql, List<Object> arguments}) _buildSql(
    Filters filters, bool doCount) {
  const queryLimit = 100;
  const queryIDsLimit = 500;
  const queryAuthorsLimit = 500;
  const queryKindsLimit = 10;
  const queryTagsLimit = 10;

  final conditions = <String>[];
  final args = <Object>[];

  if (filters.ids != null) {
    if (filters.ids!.isNotEmpty && filters.ids!.length <= queryIDsLimit) {
      args.addAll(filters.ids!);
    }
    conditions
        .add('id IN (${List.filled(filters.ids!.length, '?').join(',')})');
  }

  if (filters.authors != null) {
    if (filters.authors!.isNotEmpty &&
        filters.authors!.length <= queryAuthorsLimit) {
      args.addAll(filters.authors!);
    }
    conditions.add(
        'pubkey IN (${List.filled(filters.authors!.length, '?').join(',')})');
  }

  if (filters.kinds != null) {
    if (filters.kinds!.isNotEmpty && filters.kinds!.length <= queryKindsLimit) {
      args.addAll(filters.kinds!);
    }
    conditions
        .add('kind IN (${List.filled(filters.kinds!.length, '?').join(',')})');
  }

  int totalTags = 0;
  if (filters.tags != null) {
    filters.tags!.forEach((key, values) {
      if (values.isEmpty) {
        throw Exception('empty tag set');
      }

      final orTags = <String>[];
      for (var tagValue in values) {
        orTags.add('''tags LIKE ? ESCAPE '\'''');
        args.add('%${tagValue.replaceAll('%', '\\%')}%');
      }

      conditions.add('(${orTags.join('OR ')})');

      totalTags += values.length;
      if (totalTags > queryTagsLimit) {
        throw Exception('too many tag values');
      }
    });
  }

  if (filters.since != null) {
    conditions.add('created_at >= ?');
    args.add(filters.since!);
  }
  if (filters.until != null) {
    conditions.add('created_at <= ?');
    args.add(filters.until!);
  }

  if (conditions.isEmpty) {
    conditions.add('true');
  }

  if (filters.limit != null && filters.limit! <= queryLimit) {
    args.add(filters.limit!);
  } else {
    args.add(queryLimit);
  }

  String query = '';
  if (doCount) {
    query = '''SELECT COUNT(*) 
FROM event WHERE ${conditions.join(' AND ')} LIMIT ?''';
  } else {
    query = '''SELECT id, pubkey, created_at, kind, tags, content, sig 
FROM event WHERE ${conditions.join(' AND ')} 
ORDER BY created_at DESC, id LIMIT ?''';
  }

  return (sql: query, arguments: args);
}
