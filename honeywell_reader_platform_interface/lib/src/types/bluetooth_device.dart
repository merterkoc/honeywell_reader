class BluetoothDevice {
  const BluetoothDevice(
    this.name,
    this.address,
    this.rssi,
  );

  BluetoothDevice.fromJson(Map<String, dynamic> json)
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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BluetoothDevice &&
          runtimeType == other.runtimeType &&
          address == other.address;

  @override
  int get hashCode => address.hashCode;

  @override
  String toString() {
    return 'HoneywellBluetoothDevice{name: $name, address: $address, rssi: $rssi}';
  }
}
