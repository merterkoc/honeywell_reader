enum ScanningStatus {
  SCANNING,
  STOPPED,
  FAILURE,
  INITIAL,
}

extension ScanningStatusExtension on ScanningStatus {
  bool get isScanning => this == ScanningStatus.SCANNING;

  bool get isStopped => this == ScanningStatus.STOPPED;

  bool get isFailure => this == ScanningStatus.FAILURE;

  bool get isInitial => this == ScanningStatus.INITIAL;
}
