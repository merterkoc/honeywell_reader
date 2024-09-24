import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:honeywell_reader_android/honeywell_reader_android.dart';
import 'package:honeywell_reader_android_example/src/model/enum/operation_status.dart';
import 'package:honeywell_reader_android_example/src/model/enum/scanning_status.dart';
import 'package:honeywell_reader_android_example/src/model/scanner_settings.dart';
import 'package:honeywell_reader_platform_interface/honeywell_reader_platform_interface.dart';

part 'rfid_manager_event.dart';
part 'rfid_manager_state.dart';

class RfidManagerBloc extends Bloc<RfidManagerEvent, RfidManagerState> {
  RfidManagerBloc() : super(const RfidManagerState()) {
    on<Initialize>(_initialize);
    on<ChangeSettings>(_changeSettings);
    on<BluetoothConnectionStatusChanged>(_bluetoothConnectionStatusChanged);
    on<CheckBluetoothState>(_checkBluetoothState);
    on<BluetoothEnabledChanged>(_bluetoothEnabledChanged);
    on<ScanBluetoothDevices>(_scanBluetoothDevices);
    on<DisableScanBluetoothDevices>(_disableScanBluetoothDevices);
    on<DisconnectDevice>(_disconnectDevice);
    on<CreateReader>(_createReader);
    on<ReadStart>(_readStart);
    on<ReadStop>(_readStop);
    on<ReadStatusChanged>(_readStatusChanged);
    on<OnTagRead>(_onTagRead);
    on<ClearTags>(_clearTags);
    on<BluetoothDeviceFound>(_bluetoothDeviceFound);
    on<ConnectDevice>(_connectDevice);
    on<SetTriggerMode>(_setTriggerMode);
  }

  final _platform = AndroidHoneywellReader();
  late final StreamSubscription<ReaderStatus> statusStream;
  late final StreamSubscription<ReaderData> dataStream;
  late final StreamSubscription<BluetoothDevice> deviceStream;

  @override
  Future<void> close() async {
    await statusStream.cancel();
    await dataStream.cancel();
    await deviceStream.cancel();
    await super.close();
  }

  Future<void> _initialize(
    Initialize event,
    Emitter<RfidManagerState> emit,
  ) async {
    await _platform.init(
      ReaderInitParameters(
        autoConnect: true,
        readerMode: ReaderMode.barcode,
      ),
    );

    statusStream = _platform.statusStream().listen((status) {
      add(ReadStatusChanged(status: status));
    });

    dataStream = _platform.readStream().listen((readerData) {
      add(OnTagRead(tagRead: readerData.data));
    });

    deviceStream = _platform.deviceStream().listen((device) {
      add(BluetoothDeviceFound(device: device));
    });
    add(const CheckBluetoothState());
  }

  Future<void> _scanBluetoothDevices(
    ScanBluetoothDevices event,
    Emitter<RfidManagerState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          startScanBluetoothDevicesStatus: OperationStatus.IN_PROGRESS,
        ),
      );
      // TODO rfid bluetooth scan
      //await _platform.scan();
      emit(
        state.copyWith(
          startScanBluetoothDevicesStatus: OperationStatus.SUCCESS,
          scanBluetoothDevicesStatus: ScanningStatus.SCANNING,
        ),
      );
    } on PlatformException catch (e) {
      emit(
        state.copyWith(
          startScanBluetoothDevicesStatus: OperationStatus.FAILURE,
          scanBluetoothDevicesStatus: ScanningStatus.FAILURE,
          errorMessage: e.message,
        ),
      );
      rethrow;
    }
  }

  FutureOr<void> _disableScanBluetoothDevices(
    DisableScanBluetoothDevices event,
    Emitter<RfidManagerState> emit,
  ) {
    // TODO rfid stop bluetooth scan
    //_platform.stopScan();
  }

  FutureOr<void> _disconnectDevice(
    DisconnectDevice event,
    Emitter<RfidManagerState> emit,
  ) {
    _platform.disconnect();
  }

  Future<void> _createReader(
    CreateReader event,
    Emitter<RfidManagerState> emit,
  ) async {
    emit(state.copyWith(createReaderStatus: OperationStatus.IN_PROGRESS));
    try {
      // TODO bu nedir?
      // await _platform.createReader();
      emit(state.copyWith(createReaderStatus: OperationStatus.SUCCESS));
    } catch (e) {
      emit(state.copyWith(createReaderStatus: OperationStatus.FAILURE));
      rethrow;
    }
  }

  void _readStart(
    ReadStart event,
    Emitter<RfidManagerState> emit,
  ) {
    // TODO buna gerek var mı? tetik ile kontrol edilmeli.
    if (!state.isReadStartAllowed) return;
    // _platform.readStart();
    add(const ReadStatusChanged(status: ReaderStatus.scanning));
  }

  void _readStop(
    ReadStop event,
    Emitter<RfidManagerState> emit,
  ) {
    // TODO buna gerek var mı? tetik ile kontrol edilmeli.
    if (!state.isReadStopAllowed) return;
    // rfidManager.readStop();
    add(const ReadStatusChanged(status: ReaderStatus.idle));
  }

  FutureOr<void> _changeSettings(
    ChangeSettings event,
    Emitter<RfidManagerState> emit,
  ) {
    emit(state.copyWith(settings: event.settings));
  }

  FutureOr<void> _bluetoothConnectionStatusChanged(
    BluetoothConnectionStatusChanged event,
    Emitter<RfidManagerState> emit,
  ) {
    emit(state.copyWith(bluetoothEnabled: event.enabled));
  }

  Future<void> _checkBluetoothState(
    CheckBluetoothState event,
    Emitter<RfidManagerState> emit,
  ) async {
    final bluetoothEnabled = await _platform.isBluetoothEnabled();
    emit(
      state.copyWith(
        settings: state.settings.copyWith(
          bluetoothEnabled: bluetoothEnabled,
        ),
      ),
    );
  }

  FutureOr<void> _bluetoothEnabledChanged(
    BluetoothEnabledChanged event,
    Emitter<RfidManagerState> emit,
  ) {
    if (event.value) {
      _platform.enableBluetooth();
    } else {
      _platform.disableBluetooth();
    }
    emit(
      state.copyWith(
        settings: state.settings.copyWith(bluetoothEnabled: event.value),
      ),
    );
  }

  FutureOr<void> _onTagRead(OnTagRead event, Emitter<RfidManagerState> emit) {
    final tag = state.tags.toList()..add(event.tagRead);
    emit(state.copyWith(tags: tag.toSet()));
    debugPrint(
      'TAG READIED:${event.tagRead}' 'Total tags:${state.tags.length}',
    );
  }

  FutureOr<void> _readStatusChanged(
    ReadStatusChanged event,
    Emitter<RfidManagerState> emit,
  ) {
    emit(state.copyWith(isReading: event.status == ReaderStatus.scanning));
  }

  FutureOr<void> _clearTags(ClearTags event, Emitter<RfidManagerState> emit) {
    emit(state.copyWith(tags: <String>{}));
  }

  FutureOr<void> _bluetoothDeviceFound(
    BluetoothDeviceFound event,
    Emitter<RfidManagerState> emit,
  ) {
    final bluetoothDevices = state.bluetoothDevices.toSet()..add(event.device);
    emit(state.copyWith(bluetoothDevices: bluetoothDevices));
  }

  Future<void> _connectDevice(
    ConnectDevice event,
    Emitter<RfidManagerState> emit,
  ) async {
    emit(
      state.copyWith(manuelDeviceConnectionStatus: OperationStatus.IN_PROGRESS),
    );
    try {
      // TODO mac adresi yolla
      await _platform.connect();
      emit(
        state.copyWith(manuelDeviceConnectionStatus: OperationStatus.SUCCESS),
      );
    } on Exception {
      emit(
        state.copyWith(manuelDeviceConnectionStatus: OperationStatus.FAILURE),
      );
      rethrow;
    }
  }

  void _setTriggerMode(
    SetTriggerMode event,
    Emitter<RfidManagerState> emit,
  ) {
    _platform.changeMode(event.mode);
  }
}
