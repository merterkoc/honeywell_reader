// Copyright 2024, Suat Keskin. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// Reader Status
///
/// See also https://techdocs.zebra.com/datawedge/latest/guide/api/getscannerstatus/
enum ReaderStatus {
  /// Reader is ready to be triggered
  waiting,

  /// Reader is emitting a reader beam
  scanning,

  /// Reader is in one of the following states: enabled but not yet in the waiting state,
  /// in the suspended state by an intent (e.g. SUSPEND_PLUGIN) or disabled due to the hardware trigger
  idle,

  /// Reader is disabled
  disabled,

  /// An external (Bluetooth or serial) reader is connected
  connected,

  /// The external reader is disconnected
  disconnected;

  bool get isConnected =>
      !(this == ReaderStatus.disabled || this == ReaderStatus.disconnected);
}
