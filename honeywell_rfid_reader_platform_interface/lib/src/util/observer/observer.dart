import 'package:honeywell_reader_platform_interface/honeywell_reader_platform_interface.dart';

class Observer {
  void addObserver(Observer observer) {
    _observers.add(observer);
  }

  void removeObserver(Observer observer) {
    _observers.remove(observer);
  }

  void notifyConnectionStatus(ConnectionStatus status) {
    for (final observer in _observers) {
      observer.notifyConnectionStatus(status);
    }
  }

  void notifyTagRead(String tagRead) {
    for (final observer in _observers) {
      observer.notifyTagRead(tagRead);
    }
  }

  void notifyReadStatus({required bool isReading}) {
    for (final observer in _observers) {
      observer.notifyReadStatus(isReading: isReading);
    }
  }

  void notifyBluetoothDeviceFound(MyBluetoothDevice device) {
    for (final observer in _observers) {
      observer.notifyBluetoothDeviceFound(device);
    }
  }

  final List<Observer> _observers = [];
}
