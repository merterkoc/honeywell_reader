package com.honeywell.plugins.reader;

import androidx.annotation.NonNull;

import com.honeywell.plugins.reader.Messages.HoneywellReaderApi;

import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;

/**
 * HoneywellReaderPlugin
 */
public class HoneywellReaderPlugin implements FlutterPlugin, HoneywellReaderApi {

    private HoneywellReaderDelegate delegate;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        this.delegate = new HoneywellReaderDelegate(binding);
        HoneywellReaderApi.setUp(binding.getBinaryMessenger(), this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        HoneywellReaderApi.setUp(binding.getBinaryMessenger(), null);
        delegate.dispose();
    }

    @Override
    public void init(@NonNull Messages.InitParams params) {
        delegate.init(params.getAutoConnect(), ReadingMode.parse(params.getReaderMode()));
    }

    @Override
    public void setProperties(Map<String, Object> properties) {
        delegate.setProperties(properties);
    }

    @Override
    public void changeMode(@NonNull String mode) {
        delegate.changeMode(ReadingMode.parse(mode));
    }

    @Override
    public void connect() {
        delegate.connect();
    }

    @Override
    public void disconnect() {
        delegate.dispose();
    }

    @Override
    public void pause() {
        delegate.pause();
    }

    @Override
    public void resume() {
        delegate.start();
    }

    @Override
    public void startReading() {
        delegate.start();
    }

    @Override
    public void stopReading() {
        // TODO buna gerek var mi?
    }

    @NonNull
    @Override
    public Boolean isBluetoothEnabled() {
        return Boolean.FALSE;
    }

    @NonNull
    @Override
    public Boolean enableBluetooth() {
        return Boolean.FALSE;
    }

    @NonNull
    @Override
    public Boolean disableBluetooth() {
        return Boolean.FALSE;
    }
}
