enum ChannelAddress {
  MAIN_CHANNEL('honeywell_rfid_reader_android'),
  ON_TAG_READ('honeywell_rfid_reader_android/onTagRead');

  const ChannelAddress(this.name);

  final String name;
}
