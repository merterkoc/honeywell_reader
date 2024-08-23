import 'package:honeywell_rfid_reader_platform_interface/src/util/observer/observer.dart';

abstract class ObserverList extends Observer {
  @override
  void addObserver(Observer observer) {
    super.addObserver(observer);
    observer.addObserver(this);
  }

  @override
  void removeObserver(Observer observer) {
    super.removeObserver(observer);
    observer.removeObserver(this);
  }
}
