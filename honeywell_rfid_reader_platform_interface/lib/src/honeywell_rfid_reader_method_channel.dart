import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:honeywell_rfid_reader_platform_interface/src/constants/channel_address.dart';
import 'package:honeywell_rfid_reader_platform_interface/src/honeywell_rfid_reader_platform_interface.dart';
import 'package:honeywell_rfid_reader_platform_interface/src/model/my_bluetooth_device.dart';
import 'package:honeywell_rfid_reader_platform_interface/src/model/trigger_mode.dart';

/// An implementation of [HoneywellRfidReaderPlatform] that uses method
/// channels.
class MethodChannelHoneywellRfidReader
    extends HoneywellRfidReaderPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = MethodChannel(ChannelAddress.MAIN_CHANNEL.name);

  @visibleForTesting
  final EventChannel eventChannel =
      EventChannel(ChannelAddress.ON_TAG_READ.name);

  @override
  Future<void> initialize() {
    return methodChannel.invokeMethod('initialize');
  }

  @override
  Future<void> scanBluetoothDevices({bool bluetoothAutoConnect = false}) async {
    return methodChannel.invokeMethod(
      'scanBluetoothDevices',
      bluetoothAutoConnect,
    );
  }

  @override
  Future<void> disableScanBluetoothDevices() {
    return methodChannel.invokeMethod('disableScanBluetoothDevices');
  }

  @override
  Future<void> disconnectDevice() async {
    await methodChannel.invokeMethod('disconnectDevice');
  }

  @override
  Future<void> createReader() {
    return methodChannel.invokeMethod('createReader');
  }

  @override
  Future<void> readStart() {
    return methodChannel.invokeMethod('readStart');
  }

  @override
  Future<void> readStop() {
    return methodChannel.invokeMethod('readStop');
  }

  @override
  Future<void> bluetoothDisable() async {
    await methodChannel.invokeMethod('bluetoothDisable');
  }

  @override
  Future<void> bluetoothEnable() async {
    await methodChannel.invokeMethod('bluetoothEnable');
  }

  @override
  Future<bool> bluetoothState() async {
    return methodChannel
        .invokeMethod('bluetoothState')
        .then((value) => value as bool);
  }

  @override
  Future<bool> isConnected() async {
    return methodChannel
        .invokeMethod('checkConnection')
        .then((value) => value as bool);
  }

  @override
  Future<void> connectDevice(MyBluetoothDevice device) async {
    await methodChannel.invokeMethod('connectDevice', device.address);
  }

  @override
  Future<void> connectUsbDevice() async {
    await methodChannel.invokeMethod('connectUsbDevice');
  }

  @override
  Future<void> disconnectUsbDevice() async {
    await methodChannel.invokeMethod('disconnectUsbDevice');
  }

  @override
  Future<void> setTriggerMode(TriggerMode mode) async {
    await methodChannel.invokeMethod('setTriggerMode', mode.value);
  }
}
