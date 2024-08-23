package com.example.honeywell_rfid_reader_android.messages;

import android.content.Context;
import android.os.Handler;
import android.util.Log;

import androidx.annotation.NonNull;

import com.example.honeywell_rfid_reader_android.messages.model.MessageType;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.EventChannel;

public class DartEventBroadcaster {
    private EventChannel.EventSink eventSink;

    @NonNull
    private final Handler handler;

    public void setEventSink(EventChannel.EventSink eventSink) {
        this.eventSink = eventSink;
    }

    /**
     * Creates a new instance of the {@link DartEventBroadcaster} class.
     */
    public DartEventBroadcaster(@NonNull Context context, @NonNull Handler handler) {
        this.handler = handler;
    }

    /**
     * Sends a message to the Flutter client informing that the new tag read.
     */
    public void sendRfidReadEvent(String data) {
        send(MessageType.RFID_READ,
                new HashMap<String, Object>() {
                    {
                        put("data", data);
                    }
                }
        );
    }

    private void send(MessageType eventType, Map<String, Object> args) {
        handler.post(() -> eventSink.success(new HashMap<String, Object>() {
            {
                put("eventType", eventType.name());
                putAll(args);
            }
        }));
    }

    public void sendBluetoothDeviceFoundEvent(MyBluetoothDevice bluetoothMessage) {
        send(MessageType.BLUETOOTH_DEVICE_FOUND,
                new HashMap<String, Object>() {
                    {
                        put("device", bluetoothMessage.toMap());
                    }
                }

        );
        Log.d("sending channel: ", "sendBluetoothDeviceFoundEvent");
    }
}
