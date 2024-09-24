package com.honeywell.plugins.reader;

public enum ReadingMode {
    RFID, BARCODE;

    public static ReadingMode parse(String input) {
        for (ReadingMode value : values()) {
            if (value.name().toLowerCase().equals(input)) {
                return value;
            }
        }
        return ReadingMode.RFID;
    }

    public boolean isRfid() {
        return this == ReadingMode.RFID;
    }

    public boolean isBarcode() {
        return this == ReadingMode.BARCODE;
    }
}
