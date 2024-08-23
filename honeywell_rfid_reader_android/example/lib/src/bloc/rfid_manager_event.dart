part of 'rfid_manager_bloc.dart';

sealed class RfidManagerEvent extends Equatable {
  const RfidManagerEvent();
}

class Initialize extends RfidManagerEvent {
  const Initialize();

  @override
  List<Object?> get props => [];
}

class ChangeSettings extends RfidManagerEvent {
  const ChangeSettings({required this.settings});

  final ScannerSettings settings;

  @override
  List<Object?> get props => [
        settings,
      ];
}

class BluetoothConnectionStatusChanged extends RfidManagerEvent {
  const BluetoothConnectionStatusChanged({required this.status});

  final ConnectionStatus status;

  @override
  List<Object?> get props => [
        status,
      ];
}

class CheckBluetoothState extends RfidManagerEvent {
  const CheckBluetoothState();

  @override
  List<Object?> get props => [];
}

class BluetoothEnabledChanged extends RfidManagerEvent {
  const BluetoothEnabledChanged({required this.value});

  final bool value;

  @override
  List<Object?> get props => [
        value,
      ];
}

class ScanBluetoothDevices extends RfidManagerEvent {
  const ScanBluetoothDevices();

  @override
  List<Object?> get props => [];
}

class DisableScanBluetoothDevices extends RfidManagerEvent {
  const DisableScanBluetoothDevices();

  @override
  List<Object?> get props => [];
}

class DisconnectDevice extends RfidManagerEvent {
  const DisconnectDevice();

  @override
  List<Object?> get props => [];
}

class CreateReader extends RfidManagerEvent {
  const CreateReader();

  @override
  List<Object?> get props => [];
}

class ReadStart extends RfidManagerEvent {
  const ReadStart();

  @override
  List<Object?> get props => [];
}

class ReadStop extends RfidManagerEvent {
  const ReadStop();

  @override
  List<Object?> get props => [];
}

class ReadStatusChanged extends RfidManagerEvent {
  const ReadStatusChanged({required this.isReading});

  final bool isReading;

  @override
  List<Object?> get props => [
        isReading,
      ];
}

class OnTagRead extends RfidManagerEvent {
  const OnTagRead({required this.tagRead});

  final String tagRead;

  @override
  List<Object?> get props => [
        tagRead,
      ];
}

class ClearTags extends RfidManagerEvent {
  const ClearTags();

  @override
  List<Object?> get props => [];
}

class BluetoothDeviceFound extends RfidManagerEvent {
  const BluetoothDeviceFound({required this.device});

  final MyBluetoothDevice device;

  @override
  List<Object?> get props => [
        device,
      ];
}

class ConnectDevice extends RfidManagerEvent {
  const ConnectDevice({required this.device});

  final MyBluetoothDevice device;

  @override
  List<Object?> get props => [
        device,
      ];
}

class ConnectUsbDevice extends RfidManagerEvent {
  const ConnectUsbDevice();

  @override
  List<Object?> get props => [];
}

class DisconnectUsbDevice extends RfidManagerEvent {
  const DisconnectUsbDevice();

  @override
  List<Object?> get props => [];
}
