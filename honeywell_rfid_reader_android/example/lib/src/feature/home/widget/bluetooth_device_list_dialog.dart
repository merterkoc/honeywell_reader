import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:honeywell_rfid_reader_android_example/src/bloc/rfid_manager_bloc.dart';
import 'package:honeywell_rfid_reader_android_example/src/model/enum/operation_status.dart';
import 'package:honeywell_rfid_reader_android_example/src/model/enum/scanning_status.dart';

class BluetoothDeviceListDialog extends StatefulWidget {
  const BluetoothDeviceListDialog({super.key});

  @override
  State<BluetoothDeviceListDialog> createState() =>
      _BluetoothDeviceListDialogState();
}

class _BluetoothDeviceListDialogState extends State<BluetoothDeviceListDialog> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RfidManagerBloc, RfidManagerState>(
      listenWhen: (previous, current) =>
          previous.manuelDeviceConnectionStatus !=
          current.manuelDeviceConnectionStatus,
      listener: (context, state) {
        if (state.manuelDeviceConnectionStatus.isSuccess) {
          context
              .read<RfidManagerBloc>()
              .add(const DisableScanBluetoothDevices());
          Navigator.of(context).pop();
        }
      },
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Choose Device'),
                        if (context
                            .watch<RfidManagerBloc>()
                            .state
                            .scanBluetoothDevicesStatus
                            .isScanning)
                          const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        else
                          const SizedBox(),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: context
                            .watch<RfidManagerBloc>()
                            .state
                            .bluetoothDevices
                            .length,
                        itemBuilder: (context, index) {
                          final device = context
                              .watch<RfidManagerBloc>()
                              .state
                              .bluetoothDevices
                              .elementAt(index);
                          return BlocBuilder<RfidManagerBloc, RfidManagerState>(
                            buildWhen: (previous, current) =>
                                previous.manuelDeviceConnectionStatus !=
                                current.manuelDeviceConnectionStatus,
                            builder: (context, state) {
                              return ListTile(
                                enabled: !state
                                    .manuelDeviceConnectionStatus.isInProgress,
                                onTap: () {
                                  context
                                      .read<RfidManagerBloc>()
                                      .add(ConnectDevice(device: device));
                                },
                                title: Text(device.name ?? 'Unknown'),
                                subtitle: Text(device.address ?? 'Unknown'),
                                trailing: Text(device.rssi.toString()),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  context
                      .read<RfidManagerBloc>()
                      .add(const DisableScanBluetoothDevices());
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
