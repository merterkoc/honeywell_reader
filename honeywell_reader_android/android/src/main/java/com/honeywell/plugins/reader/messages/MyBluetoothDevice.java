package com.example.honeywell_reader_android.messages;

import java.util.HashMap;

public class MyBluetoothDevice {

    public String name;
    public String address;
    public String rssi;

    public MyBluetoothDevice(String name, String address) {
        this.name = name;
        this.address = address;
        this.rssi = "0";
    }

    public MyBluetoothDevice(String name, String address, String rssi) {
        this.name = name;
        this.address = address;
        this.rssi = rssi;
    }

    HashMap<String, Object> toMap() {
        HashMap<String, Object> map = new HashMap<>();
        map.put("name", name);
        map.put("address", address);
        map.put("rssi", rssi);
        return map;
    }
}
