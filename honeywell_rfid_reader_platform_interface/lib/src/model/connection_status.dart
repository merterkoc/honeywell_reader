enum ConnectionStatus {
  DISCONNECTED(0),
  CONNECTED(1);

  const ConnectionStatus(this.value);

  final int value;

  int getValue() {
    return value;
  }

  static ConnectionStatus fromValue(int value) {
    return ConnectionStatus.values
        .firstWhere((element) => element.value == value);
  }
}

extension ConnectionStatusExtension on ConnectionStatus {
  bool get isConnected => this == ConnectionStatus.CONNECTED;

  bool get isDisconnected => this == ConnectionStatus.DISCONNECTED;
}
