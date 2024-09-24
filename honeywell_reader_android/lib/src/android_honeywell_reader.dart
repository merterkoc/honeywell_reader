// Copyright (c) 2024, Finkoto Bilişim Teknolojileri A.Ş. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/services.dart';
import 'package:honeywell_reader_platform_interface/honeywell_reader_platform_interface.dart';

import 'messages.g.dart';

class AndroidHoneywellReader extends HoneywellReaderPlatform {
  AndroidHoneywellReader({
    @visibleForTesting HoneywellReaderApi? api,
  }) : _api = api ?? HoneywellReaderApi();

  final HoneywellReaderApi _api;

  final _readerStatusStreamController =
      StreamController<ReaderStatus>.broadcast();

  final _readerDataStreamController = StreamController<ReaderData>.broadcast();

  final _bluetoothDeviceStreamController =
      StreamController<BluetoothDevice>.broadcast();

  static void registerWith() {
    HoneywellReaderPlatform.instance = AndroidHoneywellReader();
  }

  @override
  Future<void> init(ReaderInitParameters params) {
    const MethodChannel channel = MethodChannel("plugins.honeywell.com/reader");
    channel.setMethodCallHandler(handleReaderMethodCall);

    return _api.init(InitParams(
      autoConnect: params.autoConnect,
      readerMode: params.readerMode?.name,
    ));
  }

  @override
  Future<void> setProperties(Map<String, Object> properties) {
    return _api.setProperties(properties);
  }

  @override
  Future<void> changeMode(ReaderMode mode) async {
    await _api.changeMode(mode.name);
  }

  @override
  Future<void> connect() {
    return _api.connect();
  }

  @override
  Future<void> disconnect() {
    return _api.disconnect();
  }

  @override
  Future<void> pause() {
    return _api.pause();
  }

  @override
  Future<void> resume() {
    return _api.resume();
  }

  @override
  Future<void> startReading() async {
    await _api.startReading();
  }

  @override
  Future<void> stopReading() async {
    await _api.stopReading();
  }

  @override
  Future<bool> isBluetoothEnabled() {
    return _api.isBluetoothEnabled();
  }

  @override
  Future<bool> enableBluetooth() {
    return _api.enableBluetooth();
  }

  @override
  Future<bool> disableBluetooth() {
    return _api.disableBluetooth();
  }

  @override
  Stream<ReaderStatus> statusStream() {
    return _readerStatusStreamController.stream;
  }

  @override
  Stream<ReaderData> readStream() {
    return _readerDataStreamController.stream;
  }

  @override
  Stream<BluetoothDevice> deviceStream() {
    return _bluetoothDeviceStreamController.stream;
  }

  @visibleForTesting
  Future<dynamic> handleReaderMethodCall(MethodCall call) async {
    final Map<String, dynamic> arguments = _getArgumentDictionary(call);
    switch (call.method) {
      case 'status_changed':
        _readerStatusStreamController.add(
          ReaderStatusEvent.fromJson(arguments).status,
        );
      case 'read':
        _readerDataStreamController.add(
          DataReadEvent.fromJson(arguments).readerData,
        );
      case 'bluetooth_device_discovered':
        _bluetoothDeviceStreamController.add(
          BluetoothDeviceDiscoveredEvent.fromJson(arguments).device,
        );
      default:
        throw MissingPluginException();
    }
  }

  Map<String, dynamic> _getArgumentDictionary(MethodCall call) {
    return jsonDecode(jsonEncode(call.arguments));
  }
}
