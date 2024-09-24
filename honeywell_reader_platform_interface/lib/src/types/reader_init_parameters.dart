// Copyright (c) 2024, Finkoto Bilişim Teknolojileri A.Ş. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:honeywell_reader_platform_interface/src/types/types.dart';

/// A class that contains initialization parameters for reader.
///
/// This class allows for specifying various settings when initializing reader.
class ReaderInitParameters {
  /// Creates a new [ReaderInitParameters] with the provided settings.
  ///
  /// The [autoConnect] parameter determines whether the reader should
  /// automatically connect to a reader upon initialization.
  /// It defaults to `false`.
  ReaderInitParameters({
    this.autoConnect = false,
    this.readerMode,
    this.properties = const {},
  });

  /// Whether the reader should automatically connect to reader.
  ///
  /// If set to `true`, the reader will attempt to connect to a supported device
  /// automatically during initialization. The default value is `false`.
  final bool autoConnect;

  /// Reading mode.
  ///
  /// If autoConnect set to `true`, the reader will attempt to connect to given
  /// device automatically during initialization.
  final ReaderMode? readerMode;

  /// Hardware specific properties.
  ///
  /// Used to update the default settings after connecting to the reader
  final Map<String, Object> properties;
}
