package com.example.honeywell_rfid_reader_android.bluetooth;

import android.bluetooth.BluetoothDevice;

public class BluetoothDeviceInfo {
    public BluetoothDevice dev;
    public int rssi;

    public BluetoothDeviceInfo(BluetoothDevice dev, int rssi) {
        this.dev = dev;
        this.rssi = rssi;
    }
}
