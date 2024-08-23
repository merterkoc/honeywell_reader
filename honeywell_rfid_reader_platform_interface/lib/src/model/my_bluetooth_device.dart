import 'package:equatable/equatable.dart';

class MyBluetoothDevice extends Equatable {
  const MyBluetoothDevice(this.name, this.address, this.rssi);

  MyBluetoothDevice.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        address = json['address'] as String?,
        rssi = json['rssi'] as String?;

  final String? name;
  final String? address;
  final String? rssi;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['address'] = address;
    data['rssi'] = rssi;
    return data;
  }

  @override
  String toString() {
    return 'MyBluetoothDevice{name: $name, address: $address, rssi: $rssi}';
  }

  @override
  List<Object?> get props => [name, address];
}
