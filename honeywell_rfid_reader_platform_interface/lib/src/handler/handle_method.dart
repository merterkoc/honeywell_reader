import 'package:flutter/services.dart';
import 'package:honeywell_rfid_reader_platform_interface/honeywell_rfid_reader_platform_interface.dart';
import 'package:honeywell_rfid_reader_platform_interface/src/constants/channel_address.dart';
import 'package:honeywell_rfid_reader_platform_interface/src/util/observer/observer.dart';
import 'package:honeywell_rfid_reader_platform_interface/src/util/observer/observer_list.dart';

class HandleMethod extends ObserverList {
  static final MethodChannel _channel =
      MethodChannel(ChannelAddress.MAIN_CHANNEL.name);

  static void initialize(Observer observer) {
    _channel.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case 'RFID_CONNECTION_STATUS_CHANGED':
          observer.notifyConnectionStatus(
            ConnectionStatus.values[
                (call.arguments as Map<dynamic, dynamic>)['status'] as int],
          );
        case 'RFID_READ_STATUS_CHANGED':
          observer.notifyReadStatus(
            isReading:
                (call.arguments as Map<dynamic, dynamic>)['isReading'] as bool,
          );
        default:
          throw MissingPluginException('Method not implemented');
      }
    });
  }
}

class HandleEvent extends ObserverList {
  static final EventChannel _channel =
      EventChannel(ChannelAddress.ON_TAG_READ.name);

  static void initialize(Observer observer) {
    _channel.receiveBroadcastStream().listen((dynamic event) {
      final eventType = (event as Map<dynamic, dynamic>)['eventType'] as String;
      if (eventType == 'RFID_READ') {
        observer.notifyTagRead(event['data'] as String);
      } else if (eventType == 'BLUETOOTH_DEVICE_FOUND') {
        Map<String, dynamic>.from(event['device'] as Map<dynamic, dynamic>);
        observer.notifyBluetoothDeviceFound(
          MyBluetoothDevice.fromJson(
            Map<String, dynamic>.from(
              event['device'] as Map<dynamic, dynamic>,
            ),
          ),
        );
      }
    });
  }
}
