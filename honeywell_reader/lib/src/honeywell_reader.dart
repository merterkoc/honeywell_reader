import 'dart:async';

import 'package:honeywell_reader_platform_interface/honeywell_reader_platform_interface.dart';

class HoneywellReader {
  static HoneywellReaderPlatform get _reader =>
      HoneywellReaderPlatform.instance;

  /// Initializes the reader on the device.
  ///
  /// [autoConnect] is used to immediately connect reader after init.
  Future<void> init(ReaderInitParameters params) => _reader.init(params);

  /// To update reader settings
  ///
  /// [properties] is used to send reader properties to platform implementation.
  Future<void> setProperties(Map<String, Object> properties) =>
      _reader.setProperties(properties);

  /// Changes reading mode.
  ///
  /// [mode] is used to switch between rfid and barcode reading.
  Future<void> changeMode(ReaderMode mode) => _reader.changeMode(mode);

  /// Starts reading process
  Future<void> connect() => _reader.connect();

  /// Stops reading process.
  Future<void> disconnect() => _reader.disconnect();

  /// Pause reading process.
  Future<void> pause() => _reader.pause();

  /// Resume reading process.
  Future<void> resume() => _reader.resume();

  /// Starts the reading process
  Future<void> startReading() => _reader.startReading();

  /// Stop reading process
  Future<void> stopReading() => _reader.stopReading();

  /// Returns whether Bluetooth is enabled or not
  Future<bool> get isBluetoothEnabled => _reader.isBluetoothEnabled();

  /// Enables bluetooth future.
  Future<bool> enableBluetooth() => _reader.enableBluetooth();

  /// Disables bluetooth future.
  Future<bool> disableBluetooth() => _reader.disableBluetooth();

  /// The scanner status changed.
  Stream<ReaderStatus> get statusStream => _reader.statusStream();

  /// The reader read a new barcode.
  Stream<ReaderData> get readStream => _reader.readStream();

  /// The reader detects a new device.
  Stream<BluetoothDevice> get deviceStream => _reader.deviceStream();
}
