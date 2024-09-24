// Copyright 2024, Suat Keskin. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// A class that represents the data received from reader hardware.
///
/// This class holds the information related to a reader data,
/// including the data contained in the barcode or rfid tag and the type of data.
class ReaderData {
  /// Creates a new instance of [ReaderData] with the provided [data] and [type].
  ///
  /// Both [data] and [type] are required fields and cannot be null.
  ReaderData({
    required this.data,
    required this.type,
  });

  /// The data contained in the barcode or rfid tag.
  late final String data;

  /// The type of the barcode (e.g., QR code, Code128, etc.).
  late final String type;

  /// Creates a new instance of [ReaderData] from a JSON object.
  ///
  /// The [json] parameter must include the keys 'data' and 'type'.
  ReaderData.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    type = json['type'];
  }

  /// Converts the [ReaderData] instance to a JSON object.
  ///
  /// Returns a Map with 'data' and 'type' keys containing the respective values.
  Map<String, dynamic> toJson() {
    final jsonData = <String, dynamic>{};
    jsonData['data'] = data;
    jsonData['type'] = type;
    return jsonData;
  }

  /// Compares this [ReaderData] instance with another object.
  ///
  /// Returns `true` if the other object is a [ReaderData] instance
  /// and both [data] and [type] are equal, otherwise returns `false`.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReaderData &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          data == other.data;

  /// Generates a hash code for this [ReaderData] instance.
  ///
  /// The hash code is based on the [data] and [type] properties.
  @override
  int get hashCode => type.hashCode ^ data.hashCode;

  /// Returns a string representation of this [ReaderData] instance.
  ///
  /// The string includes the [data] and [type] properties.
  @override
  String toString() {
    return 'ReaderData{data: $data, type: $type}';
  }
}
