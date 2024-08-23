import 'package:honeywell_rfid_reader_platform_interface/src/honeywell_rfid_reader_method_channel.dart';
import 'package:honeywell_rfid_reader_platform_interface/src/model/my_bluetooth_device.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class HoneywellRfidReaderPlatform extends PlatformInterface {
  HoneywellRfidReaderPlatform() : super(token: _token);

  static final Object _token = Object();

  static HoneywellRfidReaderPlatform _instance =
      MethodChannelHoneywellRfidReader();

  static HoneywellRfidReaderPlatform get instance => _instance;

  static set instance(HoneywellRfidReaderPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  Future<void> initialize();

  Future<void> scanBluetoothDevices({bool bluetoothAutoConnect = false});

  Future<void> disableScanBluetoothDevices();

  Future<void> disconnectDevice();

  Future<void> createReader();

  Future<void> readStart();

  Future<void> readStop();

  Future<bool> bluetoothState();

  Future<void> bluetoothEnable();

  Future<void> bluetoothDisable();

  Future<bool> isConnected();

  Future<void> connectDevice(MyBluetoothDevice device);

  Future<void> connectUsbDevice();

  Future<void> disconnectUsbDevice();
}
