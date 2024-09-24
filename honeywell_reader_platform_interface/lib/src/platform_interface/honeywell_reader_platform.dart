// Copyright (c) 2024, Finkoto Bilişim Teknolojileri A.Ş. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:honeywell_reader_platform_interface/src/types/types.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The interface that implementations of barcode reader must implement.
///
/// Platform implementations should extend this class rather than implement it as `reader`
/// does not consider newly added methods to be breaking changes. Extending this class
/// (using `extends`) ensures that the subclass will get the default implementation, while
/// platform implementations that `implements` this interface will be broken by newly added
/// [HoneywellReaderPlatform] methods.
abstract class HoneywellReaderPlatform extends PlatformInterface {
  /// Constructs a HoneywellReaderPlatform.
  HoneywellReaderPlatform() : super(token: _token);

  static final Object _token = Object();

  static HoneywellReaderPlatform _instance = _PlaceholderImplementation();

  /// The default instance of [HoneywellReaderPlatform] to use.
  ///
  /// Defaults to [MethodChannelHoneywellReader].
  static HoneywellReaderPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [HoneywellReaderPlatform] when they register themselves.
  static set instance(HoneywellReaderPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Initializes the reader on the device.
  ///
  /// [autoConnect] is used to immediately connect reader after init.
  Future<void> init(ReaderInitParameters params) {
    throw UnimplementedError('init() has not been implemented.');
  }

  /// To update reader settings
  Future<void> setProperties(Map<String, Object> properties) {
    throw UnimplementedError('setProperties() has not been implemented.');
  }

  /// Changes reading mode.
  Future<void> changeMode(ReaderMode mode) {
    throw UnimplementedError('changeMode() is not implemented.');
  }

  /// Starts reading process
  Future<void> connect() {
    throw UnimplementedError('connect() has not been implemented.');
  }

  /// Stops reading process.
  Future<void> disconnect() {
    throw UnimplementedError('disconnect() has not been implemented.');
  }

  /// Pause reading process.
  Future<void> pause() {
    throw UnimplementedError('pause() has not been implemented.');
  }

  /// Resume reading process.
  Future<void> resume() {
    throw UnimplementedError('resume() has not been implemented.');
  }

  /// Starts the reading process
  Future<void> startReading() {
    throw UnimplementedError('startReading() has not been implemented.');
  }

  /// Stop reading process
  Future<void> stopReading() {
    throw UnimplementedError('stopReading() is not implemented.');
  }

  /// Returns whether Bluetooth is enabled or not
  Future<bool> isBluetoothEnabled() {
    throw UnimplementedError('isBluetoothEnabled() is not implemented.');
  }

  /// Enables bluetooth future.
  Future<bool> enableBluetooth() {
    throw UnimplementedError('enableBluetooth() is not implemented.');
  }

  /// Disables bluetooth future.
  Future<bool> disableBluetooth() {
    throw UnimplementedError('disableBluetooth() is not implemented.');
  }

  /// The scanner status changed.
  Stream<ReaderStatus> statusStream() {
    throw UnimplementedError('statusStream() is not implemented.');
  }

  /// The reader read a new barcode.
  Stream<ReaderData> readStream() {
    throw UnimplementedError('readStream() is not implemented.');
  }

  /// The reader detects a new device.
  Stream<BluetoothDevice> deviceStream() {
    throw UnimplementedError('deviceStream() is not implemented.');
  }
}

class _PlaceholderImplementation extends HoneywellReaderPlatform {}
