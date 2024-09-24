// Copyright 2024, Suat Keskin. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:honeywell_reader_platform_interface/src/types/types.dart';

/// Generic Event coming from the native side of Reader.
///
/// This class is used as a base class for all the events that might be
/// triggered from a Reader, but it is never used directly as an event type.
///
/// Do NOT instantiate new events like `ReaderEvent()` directly,
/// use a specific class instead:
///
/// Do `class NewEvent extend ReaderEvent` when creating your own events.
/// See below for examples: `ReaderStatusEvent`, `DataReadEvent`...
/// These events are more semantic and more pleasant to use than raw generics.
/// They can be (and in fact, are) filtered by the `instanceof`-operator.
@immutable
abstract class ReaderEvent {}

/// An event fired when the reader status has changed.
class ReaderStatusEvent extends ReaderEvent {
  /// Build a ReaderStatusEvent event triggered from the reader.
  ///
  /// The `status` represents the reader status.
  ReaderStatusEvent({
    required this.status,
  });

  /// The reader status enum.
  late final ReaderStatus status;

  /// Converts the supplied [Map] to an instance of the [ReaderStatusEvent]
  /// class.
  ReaderStatusEvent.fromJson(Map<String, dynamic> json) {
    status = ReaderStatus.values.firstWhereOrNull(
            (d) => d.name == (json['status'] as String).toLowerCase()) ??
        ReaderStatus.disabled;
  }

  /// Converts the [ReaderStatusEvent] instance into a [Map] instance that
  /// can be serialized to JSON.
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status.name;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ReaderStatusEvent &&
              runtimeType == other.runtimeType &&
              status == other.status;

  @override
  int get hashCode => status.hashCode;
}

/// An event fired when a new barcode or rfid tag is read.
class DataReadEvent extends ReaderEvent {
  /// Build a DataReadEvent event triggered from the reader.
  ///
  /// The `barcode` represents the barcode data and type.
  DataReadEvent({
    required this.readerData,
  });

  /// The barcode data.
  late final ReaderData readerData;

  /// Converts the supplied [Map] to an instance of the [DataReadEvent]
  /// class.
  DataReadEvent.fromJson(Map<String, dynamic> json) {
    readerData = ReaderData.fromJson(json['reader_data']);
  }

  /// Converts the [DataReadEvent] instance into a [Map] instance that
  /// can be serialized to JSON.
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['reader_data'] = readerData.toJson();
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DataReadEvent &&
              runtimeType == other.runtimeType &&
              readerData == other.readerData;

  @override
  int get hashCode => readerData.hashCode;

  @override
  String toString() {
    return 'DataReadEvent{readerData: $readerData}';
  }
}

/// An event fired when a new bluetooth device is detected.
class BluetoothDeviceDiscoveredEvent extends ReaderEvent {
  /// Build a BluetoothDeviceDiscoveredEvent event triggered from the reader.
  ///
  /// The `device` includes the name and address of device.
  BluetoothDeviceDiscoveredEvent({
    required this.device,
  });

  /// The barcode data.
  late final BluetoothDevice device;

  /// Converts the supplied [Map] to an instance of the [DataReadEvent]
  /// class.
  BluetoothDeviceDiscoveredEvent.fromJson(Map<String, dynamic> json) {
    device = BluetoothDevice.fromJson(json['device']);
  }

  /// Converts the [BluetoothDeviceDiscoveredEvent] instance into a [Map] instance
  /// that can be serialized to JSON.
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['device'] = device.toJson();
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is BluetoothDeviceDiscoveredEvent &&
              runtimeType == other.runtimeType &&
              device == other.device;

  @override
  int get hashCode => device.hashCode;

  @override
  String toString() {
    return 'BluetoothDeviceDiscoveredEvent{device: $device}';
  }
}
