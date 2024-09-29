library eventstore;

import 'package:fixnum/fixnum.dart';
import 'package:nip01/nip01.dart';

abstract interface class Store {
  Future<void> init();
  Future<void> close();

  Future<List<Event>> queryEvents(Filters filter);
  Future<void> deleteEvent(Event event);
  Future<void> saveEvent(Event event);
}

abstract interface class Counter {
  Future<Int64> countEvents(Filters filter);
}
