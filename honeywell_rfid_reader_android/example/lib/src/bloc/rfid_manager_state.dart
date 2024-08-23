part of 'rfid_manager_bloc.dart';

@immutable
class RfidManagerState extends Equatable {
  const RfidManagerState({
    required this.settings,
    required this.createReaderStatus,
    required this.bluetoothStatus,
    required this.scanBluetoothDevicesStatus,
    required this.tags,
    required this.startScanBluetoothDevicesStatus,
    this.previous,
    this.isReading = false,
    this.errorMessage,
    this.bluetoothDevices = const {},
    this.manuelDeviceConnectionStatus = OperationStatus.INITIAL,
  });

  const RfidManagerState.initial()
      : this(
          settings: const ScannerSettings(),
          previous: null,
          tags: const {},
          bluetoothStatus: ConnectionStatus.DISCONNECTED,
          createReaderStatus: OperationStatus.INITIAL,
          scanBluetoothDevicesStatus: ScanningStatus.INITIAL,
          errorMessage: null,
          bluetoothDevices: const <MyBluetoothDevice>{},
          isReading: false,
          startScanBluetoothDevicesStatus: OperationStatus.INITIAL,
          manuelDeviceConnectionStatus: OperationStatus.INITIAL,
        );

  final ScannerSettings settings;
  final RfidManagerState? previous;
  final Set<String> tags;
  final ConnectionStatus bluetoothStatus;
  final ScanningStatus scanBluetoothDevicesStatus;
  final OperationStatus createReaderStatus;
  final bool isReading;
  final String? errorMessage;
  final Set<MyBluetoothDevice> bluetoothDevices;
  final OperationStatus startScanBluetoothDevicesStatus;
  final OperationStatus manuelDeviceConnectionStatus;

  RfidManagerState copyWith({
    ScannerSettings? settings,
    Set<String>? tags,
    ConnectionStatus? bluetoothStatus,
    ScanningStatus? scanBluetoothDevicesStatus,
    OperationStatus? createReaderStatus,
    bool? isReading,
    String? errorMessage,
    Set<MyBluetoothDevice>? bluetoothDevices,
    OperationStatus? startScanBluetoothDevicesStatus,
    OperationStatus? manuelDeviceConnectionStatus,
  }) {
    return RfidManagerState(
      settings: settings ?? this.settings,
      previous: this,
      tags: tags ?? this.tags,
      bluetoothStatus: bluetoothStatus ?? this.bluetoothStatus,
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
      bluetoothStatus.isConnected && createReaderStatus.isSuccess && !isReading;

  bool get isReadStopAllowed =>
      bluetoothStatus.isConnected && createReaderStatus.isSuccess && isReading;

  @override
  List<Object?> get props => [
        settings,
        previous,
        tags,
        bluetoothStatus,
        scanBluetoothDevicesStatus,
        createReaderStatus,
        bluetoothDevices,
        startScanBluetoothDevicesStatus,
        manuelDeviceConnectionStatus,
      ];
}
