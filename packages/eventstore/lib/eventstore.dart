library eventstore;

import 'package:fixnum/fixnum.dart';
import 'package:nip01/nip01.dart';

abstract interface class Store {
  void init();
  void close();

  Stream<Event> queryEvents(Filters filter);
  deleteEvent(Event event);
  saveEvent(Event event);
}

abstract interface class Counter {
  Int64 countEvents(Filters filter);
}
