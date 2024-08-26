// import 'package:flutter_test/flutter_test.dart';
// import 'package:honeywell_reader_android/honeywell_reader_method_channel.dart';
// import 'package:honeywell_reader_android/honeywell_reader_platform_interface.dart';
// import 'package:honeywell_reader_android/model/my_bluetooth_device.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';
//
// class MockHoneywellRfidReaderAndroidPlatform
//     with MockPlatformInterfaceMixin
//     implements HoneywellRfidReaderPlatform {
//   void main() {
//     final initialPlatform = HoneywellRfidReaderPlatform.instance;
//
//     test('$MethodChannelHoneywellRfidReader is the default instance',
//         () {
//       expect(
//         initialPlatform,
//         isInstanceOf<MethodChannelHoneywellRfidReader>(),
//       );
//     });
//
//     test('MethodChannelHoneywellRfidReaderAndroid', () async {
//       final fakePlatform = MockHoneywellRfidReaderAndroidPlatform();
//       HoneywellRfidReaderPlatform.instance = fakePlatform;
//     });
//   }
//
//   @override
//   Future<void> disconnectDevice() {
//     // TODO(mert): implement disconnectDevice
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<void> initialize() {
//     // TODO(mert): implement initialize
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<void> scanBluetoothDevices({bool bluetoothAutoConnect = false}) {
//     // TODO(mert): implement scanBluetoothDevices
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<void> disableScanBluetoothDevices() {
//     // TODO(mert): implement disableScanBluetoothDevices
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<void> createReader() {
//     // TODO(mert): implement createReader
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<void> readStart() {
//     // TODO(mert): implement readStart
//
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<void> readStop() {
//     // TODO(mert): implement readStop
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<void> bluetoothDisable() {
//     // TODO(mert): implement bluetoothDisable
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<void> bluetoothEnable() {
//     // TODO(mert): implement bluetoothEnable
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<bool> bluetoothState() {
//     // TODO(mert): implement bluetoothState
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<bool> isConnected() {
//     // TODO(mert): implement isConnected
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<void> connectDevice(MyBluetoothDevice device) {
//     // TODO(mert): implement connectDevice
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<void> connectUsbDevice() {
//     // TODO(mert): implement connectUsbDevice
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<void> disconnectUsbDevice() {
//     // TODO(mert): implement disconnectUsbDevice
//     throw UnimplementedError();
//   }
// }
