package com.example.honeywell_rfid_reader_android.messages.model;

public enum MessageType {
    RFID_CONNECTION_STATUS_CHANGED,
    RFID_READ,
    RFID_READ_STATUS_CHANGED,

    ERROR, BLUETOOTH_DEVICE_FOUND;
}