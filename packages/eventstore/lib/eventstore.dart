library eventstore;

import 'package:fixnum/fixnum.dart';
import 'package:nip01/nip01.dart';

abstract interface class Store {
  void init();
  void close();

  List<Event> queryEvents(Filters filter);
  void deleteEvent(Event event);
  void saveEvent(Event event);
}

abstract interface class Counter {
  Int64 countEvents(Filters filter);
}
