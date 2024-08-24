enum TriggerMode {
  RFID('RFID'),
  BARCODE('BARCODE');

  const TriggerMode(this.value);

  final String value;

  String getValue() {
    return value;
  }

  static TriggerMode fromValue(int value) {
    return TriggerMode.values.firstWhere((element) => element.value == value);
  }
}

extension TriggerModeExtension on TriggerMode {
  bool get isRFID => this == TriggerMode.RFID;

  bool get isBarcode => this == TriggerMode.BARCODE;
}
