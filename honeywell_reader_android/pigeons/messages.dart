// Copyright (c) 2024, Finkoto Bilişim Teknolojileri A.Ş. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:pigeon/pigeon.dart';

class InitParams {
  const InitParams({
    this.autoConnect = false,
    this.readerMode,
  });

  final bool autoConnect;
  final String? readerMode;
}

class BarcodeReaderDto {
  const BarcodeReaderDto({
    required this.name,
  });

  final String name;
}

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/src/messages.g.dart',
  javaOut: 'android/src/main/java/com/honeywell/plugins/reader/Messages.java',
  javaOptions: JavaOptions(package: 'com.honeywell.plugins.reader'),
  copyrightHeader: 'pigeons/copyright.txt',
))
@HostApi()
abstract class HoneywellReaderApi {
  void init(InitParams params);

  void setProperties(Map<String, Object> properties);

  void changeMode(String mode);

  void connect();

  void disconnect();

  void pause();

  void resume();

  void startReading();

  void stopReading();

  bool isBluetoothEnabled();

  bool enableBluetooth();

  bool disableBluetooth();
}
