package com.example.honeywell_reader_android.messages;

import android.content.Context;
import android.os.Handler;

import androidx.annotation.NonNull;

import com.example.honeywell_reader_android.messages.model.ConnectionStatus;
import com.example.honeywell_reader_android.messages.model.MessageType;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;

public class DartMessenger {
    @NonNull
    private final MethodChannel readerChannel;

    @NonNull
    private final Handler handler;
    @NonNull
    private final Context context;

    /**
     * Creates a new instance of the {@link DartMessenger} class.
     */
    public DartMessenger(@NonNull Context context, @NonNull MethodChannel readerChannel, @NonNull Handler handler) {
        this.context = context;
        this.readerChannel = readerChannel;
        this.handler = handler;
    }

    public void sendRfidConnectionStatusEvent(ConnectionStatus connectionStatus) {
        this.send(MessageType.RFID_CONNECTION_STATUS_CHANGED,
                new HashMap<String, Object>() {
                    {
                        put("status", connectionStatus.getStatusCode());
                    }
                });
    }

    public void sendRfidReadStatusEvent(boolean isReading) {
        this.send(MessageType.RFID_READ_STATUS_CHANGED,
                new HashMap<String, Object>() {
                    {
                        put("isReading", isReading);
                    }
                });
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

    public void sendReaderErrorEvent(String errorMessage) {
        this.send(
                MessageType.ERROR,
                new HashMap<String, Object>() {
                    {
                        put("message", errorMessage);
                    }
                }
        );
    }

    private void send(MessageType eventType) {
        send(eventType, new HashMap<>());
    }

    private void send(MessageType eventType, Map<String, Object> args) {
        handler.post(() -> readerChannel.invokeMethod(eventType.name(), args));
    }
}
