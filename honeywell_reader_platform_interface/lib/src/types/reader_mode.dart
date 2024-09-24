enum ReaderMode {
  rfid,
  barcode;

  static ReaderMode parse(String value) {
    return ReaderMode.values.firstWhere((element) => element.name == value);
  }
}

extension TriggerModeExtension on ReaderMode {
  bool get isRFID => this == ReaderMode.rfid;

  bool get isBarcode => this == ReaderMode.barcode;
}
