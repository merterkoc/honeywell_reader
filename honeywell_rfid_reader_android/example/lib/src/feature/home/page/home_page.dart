import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:honeywell_rfid_reader/honeywell_rfid_reader.dart';
import 'package:honeywell_rfid_reader_android_example/src/bloc/rfid_manager_bloc.dart';
import 'package:honeywell_rfid_reader_android_example/src/feature/home/widget/bluetooth_device_list_dialog.dart';
import 'package:honeywell_rfid_reader_android_example/src/feature/home/widget/bluetooth_settings_widget.dart';
import 'package:honeywell_rfid_reader_android_example/src/feature/reader/page/reader_page.dart';
import 'package:honeywell_rfid_reader_android_example/src/model/enum/operation_status.dart';
import 'package:honeywell_rfid_reader_android_example/src/model/enum/scanning_status.dart';
import 'package:honeywell_rfid_reader_android_example/src/widget/card_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Honeywell RFID Reader'),
        leading: BlocBuilder<RfidManagerBloc, RfidManagerState>(
          buildWhen: (previous, current) =>
              previous.bluetoothStatus != current.bluetoothStatus,
          builder: (context, state) {
            return Icon(
              state.bluetoothStatus == ConnectionStatus.CONNECTED
                  ? Icons.bluetooth_connected
                  : Icons.bluetooth_disabled,
              color: state.bluetoothStatus == ConnectionStatus.CONNECTED
                  ? Colors.green
                  : Colors.red,
            );
          },
        ),
      ),
      body: BlocListener<RfidManagerBloc, RfidManagerState>(
        listenWhen: (previous, current) =>
            previous.scanBluetoothDevicesStatus !=
            current.scanBluetoothDevicesStatus,
        listener: (context, state) {
          if (state.errorMessage == null) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? ''),
              duration: const Duration(seconds: 2),
              padding: const EdgeInsets.all(8),
            ),
          );
        },
        child: SingleChildScrollView(
          child: Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                const BluetoothSettingsWidget(),
                BlocListener<RfidManagerBloc, RfidManagerState>(
                  listenWhen: (previous, current) =>
                      previous.startScanBluetoothDevicesStatus !=
                      current.startScanBluetoothDevicesStatus,
                  listener: (context, state) {
                    if (state.scanBluetoothDevicesStatus.isScanning &&
                        !state.settings.autoConnect &&
                        state.startScanBluetoothDevicesStatus.isSuccess) {
                      showDialog<void>(
                        useRootNavigator: false,
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) =>
                            const BluetoothDeviceListDialog(),
                      );
                    }
                  },
                  child: CardButton(
                    onPressed: () => context
                        .read<RfidManagerBloc>()
                        .add(const ScanBluetoothDevices()),
                    icon: Icons.bluetooth_searching,
                    label: 'Scan',
                  ),
                ),
                CardButton(
                  onPressed: () => context
                      .read<RfidManagerBloc>()
                      .add(const DisableScanBluetoothDevices()),
                  icon: Icons.bluetooth_disabled,
                  label: 'Disable Scan',
                ),
                CardButton(
                  onPressed: () => context
                      .read<RfidManagerBloc>()
                      .add(const DisconnectDevice()),
                  icon: Icons.bluetooth_disabled,
                  label: 'Disconnect',
                ),
                CardButton(
                  onPressed: () => context
                      .read<RfidManagerBloc>()
                      .add(const ConnectUsbDevice()),
                  icon: Icons.usb,
                  label: 'Connect USB',
                ),
                CardButton(
                  onPressed: () => context
                      .read<RfidManagerBloc>()
                      .add(const DisconnectUsbDevice()),
                  icon: Icons.usb,
                  label: 'Disconnect USB',
                ),
                BlocBuilder<RfidManagerBloc, RfidManagerState>(
                  buildWhen: (previous, current) =>
                      previous.bluetoothStatus != current.bluetoothStatus ||
                      previous.createReaderStatus != current.createReaderStatus,
                  builder: (context, state) {
                    return Opacity(
                      opacity: state.bluetoothStatus.isConnected ? 1 : 0.5,
                      child: CardButton(
                        icon: state.createReaderStatus ==
                                OperationStatus.IN_PROGRESS
                            ? Icons.bluetooth_searching
                            : Icons.barcode_reader,
                        onPressed: () {
                          if (state.bluetoothStatus !=
                              ConnectionStatus.CONNECTED) {
                            return;
                          }
                          context
                              .read<RfidManagerBloc>()
                              .add(const CreateReader());
                          debugPrint('created reader');
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (context) => const ReaderPage(),
                            ),
                          );
                        },
                        label: 'Create Reader',
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
