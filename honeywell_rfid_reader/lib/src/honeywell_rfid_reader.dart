import 'dart:async';

import 'package:honeywell_rfid_reader_platform_interface/honeywell_rfid_reader_platform_interface.dart';
import 'package:permission_handler/permission_handler.dart';

class RFIDManager extends Observer {
  factory RFIDManager() {
    _instance ??= RFIDManager._internal();
    _honeywellPlugin = HoneywellRfidReaderPlatform.instance;
    HandleMethod.initialize(_instance!);
    HandleEvent.initialize(_instance!);
    return _instance!;
  }

  RFIDManager._internal();

  static late final HoneywellRfidReaderPlatform _honeywellPlugin;

  static RFIDManager? _instance;

  final _connectionStatusChanged =
      StreamController<ConnectionStatus>.broadcast();

  Stream<ConnectionStatus> get connectionStatusChangedStream =>
      _connectionStatusChanged.stream;

  final _tagRead = StreamController<String>.broadcast();

  Stream<String> get tagReadStream => _tagRead.stream;

  final _readStatusChanged = StreamController<bool>.broadcast();

  Stream<bool> get readStatusChangedStream => _readStatusChanged.stream;

  final _bluetoothDeviceFound = StreamController<MyBluetoothDevice>.broadcast();

  Stream<MyBluetoothDevice> get bluetoothDeviceFoundStream =>
      _bluetoothDeviceFound.stream;

  void initialize() {
    //checkConnection();
  }

  Future<void> scanBluetoothDevices({bool bluetoothAutoConnect = false}) async {
    const permission = Permission.bluetoothScan;
    const Permission locationPermission = Permission.location;
    if (await permission.request().isGranted &&
        await locationPermission.request().isGranted) {
      return _honeywellPlugin.scanBluetoothDevices(
        bluetoothAutoConnect: bluetoothAutoConnect,
      );
    }
    throw Exception('Permission not granted');
  }

  Future<void> disableScanBluetoothDevices() async {
    return _honeywellPlugin.disableScanBluetoothDevices();
  }

  Future<void> disconnectDevice() async {
    await _honeywellPlugin.disconnectDevice();
  }

  Future<void> createReader() async {
    await _honeywellPlugin.createReader();
  }

  Future<void> readStart() async {
    await _honeywellPlugin.readStart();
  }

  Future<void> readStop() async {
    await _honeywellPlugin.readStop();
  }

  Future<bool> bluetoothState() async {
    return _honeywellPlugin.bluetoothState();
  }

  Future<void> bluetoothEnable() async {
    await _honeywellPlugin.bluetoothEnable();
  }

  Future<void> bluetoothDisable() async {
    await _honeywellPlugin.bluetoothDisable();
  }

  Future<void> checkConnection() async {
    final connected = await _honeywellPlugin.isConnected();
    if (connected) {
      _connectionStatusChanged.add(ConnectionStatus.CONNECTED);
    }
  }

  @override
  void notifyConnectionStatus(ConnectionStatus status) {
    _connectionStatusChanged.add(status);
  }

  @override
  void notifyTagRead(String tagRead) {
    _tagRead.add(tagRead);
  }

  @override
  void notifyReadStatus({required bool isReading}) {
    _readStatusChanged.add(isReading);
  }

  @override
  void notifyBluetoothDeviceFound(MyBluetoothDevice device) {
    _bluetoothDeviceFound.add(device);
  }

  Future<void> connectDevice(MyBluetoothDevice device) async {
    await _honeywellPlugin.connectDevice(device);
  }

  Future<void> connectUsbDevice() async {
    await _honeywellPlugin.connectUsbDevice();
  }

  Future<void> disconnectUsbDevice() async {
    await _honeywellPlugin.disconnectUsbDevice();
  }

  void close() {
    _connectionStatusChanged.close();
    _tagRead.close();
  }
}
