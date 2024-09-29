library eventstore_sqflite;

import 'package:fixnum/fixnum.dart';
import 'package:nostr_core_dart/nostr.dart';

abstract interface class Store {
  void init();
  void close();

  Stream<Event> queryEvents(Filter filter);
  deleteEvent(Event event);
  saveEvent(Event event);
}

abstract interface class Counter {
  Int64 countEvents(Filter filter);
}
