part of 'rfid_manager_bloc.dart';

@immutable
class RfidManagerState extends Equatable {
  const RfidManagerState({
    this.settings = const ScannerSettings(),
    this.createReaderStatus = OperationStatus.INITIAL,
    this.bluetoothEnabled = false,
    this.scanBluetoothDevicesStatus = ScanningStatus.INITIAL,
    this.tags = const {},
    this.startScanBluetoothDevicesStatus = OperationStatus.INITIAL,
    this.previous,
    this.isReading = false,
    this.errorMessage,
    this.bluetoothDevices = const {},
    this.manuelDeviceConnectionStatus = OperationStatus.INITIAL,
  });

  final ScannerSettings settings;
  final RfidManagerState? previous;
  final Set<String> tags;
  final bool bluetoothEnabled;
  final ScanningStatus scanBluetoothDevicesStatus;
  final OperationStatus createReaderStatus;
  final bool isReading;
  final String? errorMessage;
  final Set<BluetoothDevice> bluetoothDevices;
  final OperationStatus startScanBluetoothDevicesStatus;
  final OperationStatus manuelDeviceConnectionStatus;

  RfidManagerState copyWith({
    ScannerSettings? settings,
    Set<String>? tags,
    bool? bluetoothEnabled,
    ScanningStatus? scanBluetoothDevicesStatus,
    OperationStatus? createReaderStatus,
    bool? isReading,
    String? errorMessage,
    Set<BluetoothDevice>? bluetoothDevices,
    OperationStatus? startScanBluetoothDevicesStatus,
    OperationStatus? manuelDeviceConnectionStatus,
  }) {
    return RfidManagerState(
      settings: settings ?? this.settings,
      previous: this,
      tags: tags ?? this.tags,
      bluetoothEnabled: bluetoothEnabled ?? this.bluetoothEnabled,
      scanBluetoothDevicesStatus:
          scanBluetoothDevicesStatus ?? this.scanBluetoothDevicesStatus,
      createReaderStatus: createReaderStatus ?? this.createReaderStatus,
      isReading: isReading ?? this.isReading,
      errorMessage: errorMessage ?? this.errorMessage,
      bluetoothDevices: bluetoothDevices ?? this.bluetoothDevices,
      startScanBluetoothDevicesStatus: startScanBluetoothDevicesStatus ??
          this.startScanBluetoothDevicesStatus,
      manuelDeviceConnectionStatus:
          manuelDeviceConnectionStatus ?? this.manuelDeviceConnectionStatus,
    );
  }

  bool get isReadStartAllowed =>
      bluetoothEnabled && createReaderStatus.isSuccess && !isReading;

  bool get isReadStopAllowed =>
      bluetoothEnabled && createReaderStatus.isSuccess && isReading;

  @override
  List<Object?> get props => [
        settings,
        previous,
        tags,
        bluetoothEnabled,
        scanBluetoothDevicesStatus,
        createReaderStatus,
        bluetoothDevices,
        startScanBluetoothDevicesStatus,
        manuelDeviceConnectionStatus,
      ];
}
