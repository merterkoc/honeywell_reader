// Copyright 2024, Suat Keskin. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package com.honeywell.plugins.reader;

import android.content.Context;
import android.os.Handler;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.honeywell.plugins.reader.dart.ReaderStatus;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;

/**
 * Utility class that facilitates communication to the Flutter client
 */
public class DartMessenger {
    @NonNull
    private final MethodChannel readerChannel;
    @NonNull
    private final Handler handler;
    @NonNull
    private final Context context;

    /**
     * Specifies the different reader related message types.
     */
    enum ReaderEventType {
        /**
         * Indicates that an error occurred while interacting with the reader.
         */
        ERROR("error"),
        /**
         * Indicates that the new barcode tag read occurred.
         */
        TAG_READ("read"),
        /**
         * Indicates that the reader status changed
         */
        READER_STATUS("status_changed"),
        /**
         * Indicates that the new bluetooth device discovered
         */
        BLUETOOTH_DEVICE_DISCOVERED("bluetooth_device_discovered");

        final String method;

        /**
         * Converts the supplied method name to the matching {@link ReaderEventType}.
         *
         * @param method name to be converted into a {@link ReaderEventType}.
         */
        ReaderEventType(String method) {
            this.method = method;
        }
    }

    /**
     * Creates a new instance of the {@link DartMessenger} class.
     */
    DartMessenger(@NonNull Context context, @NonNull MethodChannel readerChannel, @NonNull Handler handler) {
        this.context = context;
        this.readerChannel = readerChannel;
        this.handler = handler;
    }

    /**
     * Sends a message to the Flutter client informing that the new tag read.
     */
    public void sendTagReadEvent(String type, String data) {
        send(ReaderEventType.TAG_READ,
                new HashMap<String, Object>() {
                    {
                        put("reader_data", new HashMap<String, Object>() {
                            {
                                put("type", type);
                                put("data", data);
                            }
                        });
                    }
                }
        );
    }

    /**
     * Sends a message to the Flutter client informing that the scanner status changed.
     */
    public void sendReaderStatusEvent(ReaderStatus readerStatus) {
        this.send(ReaderEventType.READER_STATUS,
                new HashMap<String, Object>() {
                    {
                        put("status", readerStatus.name());
                    }
                });
    }

    /**
     * Sends a message to the Flutter client informing that an error occurred while interacting with
     * the reader.
     *
     * @param code contains details regarding the error that occurred.
     */
    public void sendReaderErrorEvent(int code) {
        this.send(
                ReaderEventType.ERROR,
                new HashMap<String, Object>() {
                    {
                        put("message", context.getString(code));
                    }
                }
        );
    }

    /**
     * Sends a message to the Flutter client informing that an error occurred while interacting with
     * the reader.
     *
     * @param description contains details regarding the error that occurred.
     */
    public void sendReaderErrorEvent(@Nullable String description) {
        this.send(
                ReaderEventType.ERROR,
                new HashMap<String, Object>() {
                    {
                        put("message", description);
                    }
                }
        );
    }

    private void send(ReaderEventType eventType) {
        send(eventType, new HashMap<>());
    }

    private void send(ReaderEventType eventType, Map<String, Object> args) {
        handler.post(() -> readerChannel.invokeMethod(eventType.method, args));
    }
}
