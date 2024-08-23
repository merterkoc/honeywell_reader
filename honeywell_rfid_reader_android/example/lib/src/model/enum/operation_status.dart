enum OperationStatus {
  SUCCESS,
  FAILURE,
  IN_PROGRESS,
  INITIAL,
}

extension OperationStatusExtension on OperationStatus {
  bool get isSuccess => this == OperationStatus.SUCCESS;

  bool get isFailure => this == OperationStatus.FAILURE;

  bool get isInProgress => this == OperationStatus.IN_PROGRESS;
}
