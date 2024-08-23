package com.example.honeywell_rfid_reader_android.helper.observer;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import com.example.honeywell_rfid_reader_android.messages.DartMessenger;

public class TagChangeBroadcastReceiver extends BroadcastReceiver {

    public TagChangeListener callback;

    public DartMessenger dartMessenger;

    public void setListener(TagChangeListener callback) {
        this.callback = callback;
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        if (intent != null && "action.TAG_CHANGE".equals(intent.getAction())) {
            TagInfo info = intent.getParcelableExtra("tagInfo");
            Log.d("onReceive", "onReceive");
            if (callback != null) {
                callback.onTagChange(info);
            }
        }
    }
}