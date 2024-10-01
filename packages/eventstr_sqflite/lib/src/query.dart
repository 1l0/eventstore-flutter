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
    final ids = filters.ids!;
    if (ids.isNotEmpty && ids.length <= queryIDsLimit) {
      args.addAll(ids);
    }
    conditions.add('id IN (${List.filled(ids.length, '?').join(',')})');
  }

  if (filters.authors != null) {
    final authors = filters.authors!;
    if (authors.isNotEmpty && authors.length <= queryAuthorsLimit) {
      args.addAll(authors);
    }
    conditions.add('pubkey IN (${List.filled(authors.length, '?').join(',')})');
  }

  if (filters.kinds != null) {
    final kinds = filters.kinds!;
    if (kinds.isNotEmpty && kinds.length <= queryKindsLimit) {
      args.addAll(kinds);
    }
    conditions.add('kind IN (${List.filled(kinds.length, '?').join(',')})');
  }

  int totalTags = 0;
  if (filters.tags != null) {
    final tags = filters.tags!;
    tags.forEach((key, values) {
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
    final since = filters.since!;
    conditions.add('created_at >= ?');
    args.add(since);
  }
  if (filters.until != null) {
    final until = filters.until!;
    conditions.add('created_at <= ?');
    args.add(until);
  }
  // TODO: search

  if (conditions.isEmpty) {
    conditions.add('true');
  }

  if (filters.limit != null && filters.limit! <= queryLimit) {
    final limit = filters.limit!;
    args.add(limit);
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
