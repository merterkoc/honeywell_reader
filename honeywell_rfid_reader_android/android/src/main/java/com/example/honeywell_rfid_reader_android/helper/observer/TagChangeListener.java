package com.example.honeywell_rfid_reader_android.helper.observer;

import com.example.honeywell_rfid_reader_android.HoneywellRfidReaderAndroidPlugin;

public abstract class TagChangeListener {
    public abstract void onTagChange(TagInfo tagInfo);
}