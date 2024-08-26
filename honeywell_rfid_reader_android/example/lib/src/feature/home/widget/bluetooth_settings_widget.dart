import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:honeywell_reader_android_example/src/bloc/rfid_manager_bloc.dart';

class BluetoothSettingsWidget extends StatelessWidget {
  const BluetoothSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlocBuilder<RfidManagerBloc, RfidManagerState>(
          buildWhen: (previous, current) =>
              previous.settings.bluetoothEnabled !=
              current.settings.bluetoothEnabled,
          builder: (context, state) {
            return Switch.adaptive(
              value: state.settings.bluetoothEnabled,
              onChanged: (value) {
                context
                    .read<RfidManagerBloc>()
                    .add(BluetoothEnabledChanged(value: value));
              },
            );
          },
        ),
        const SizedBox(width: 8),
        const Text(
          'Bluetooth',
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(width: 8),
        BlocBuilder<RfidManagerBloc, RfidManagerState>(
          buildWhen: (previous, current) =>
              previous.settings != current.settings,
          builder: (context, state) {
            return Switch.adaptive(
              value: state.settings.autoConnect,
              onChanged: (value) {
                context.read<RfidManagerBloc>().add(
                      ChangeSettings(
                        settings: state.settings.copyWith(autoConnect: value),
                      ),
                    );
              },
            );
          },
        ),
        const SizedBox(width: 8),
        const Text(
          'Auto Connect',
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
