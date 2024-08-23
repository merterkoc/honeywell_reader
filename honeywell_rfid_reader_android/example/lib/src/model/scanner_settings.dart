import 'package:equatable/equatable.dart';

class ScannerSettings extends Equatable {
  const ScannerSettings({
    this.autoConnect = false,
    this.scanOnlyConnectedDevices = false,
    this.scanDuration = 10,
    this.bluetoothEnabled = false,
  });

  final bool autoConnect;
  final bool scanOnlyConnectedDevices;
  final int scanDuration;
  final bool bluetoothEnabled;

  ScannerSettings copyWith({
    bool? autoConnect,
    bool? scanOnlyConnectedDevices,
    int? scanDuration,
    bool? bluetoothEnabled,
  }) {
    return ScannerSettings(
      autoConnect: autoConnect ?? this.autoConnect,
      scanOnlyConnectedDevices:
          scanOnlyConnectedDevices ?? this.scanOnlyConnectedDevices,
      scanDuration: scanDuration ?? this.scanDuration,
      bluetoothEnabled: bluetoothEnabled ?? this.bluetoothEnabled,
    );
  }

  @override
  List<Object?> get props => [
        autoConnect,
        scanOnlyConnectedDevices,
        scanDuration,
        bluetoothEnabled,
      ];
}
