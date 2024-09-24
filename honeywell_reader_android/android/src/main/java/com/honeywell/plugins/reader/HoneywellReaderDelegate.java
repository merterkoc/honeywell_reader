package com.honeywell.plugins.reader;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;

import com.honeywell.aidc.AidcManager;
import com.honeywell.aidc.BarcodeFailureEvent;
import com.honeywell.aidc.BarcodeReadEvent;
import com.honeywell.aidc.BarcodeReader;
import com.honeywell.aidc.InvalidScannerNameException;
import com.honeywell.aidc.ScannerUnavailableException;
import com.honeywell.aidc.UnsupportedPropertyException;
import com.honeywell.plugins.reader.dart.ReaderStatus;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodChannel;

public class HoneywellReaderDelegate implements AidcManager.CreatedCallback, BarcodeReader.BarcodeListener {
    private static final Map<String, Object> DEFAULT_BARCODE_READER_PROPS;
    private final Context applicationContext;
    private final DartMessenger dartMessenger;
    private AidcManager aidcManager;
    private BarcodeReader barcodeReader;
    private boolean autoConnect = false;
    private ReadingMode readingMode = ReadingMode.RFID;

    static {
        DEFAULT_BARCODE_READER_PROPS = new HashMap<>();
        DEFAULT_BARCODE_READER_PROPS.put(BarcodeReader.PROPERTY_AZTEC_ENABLED, true);
        DEFAULT_BARCODE_READER_PROPS.put(BarcodeReader.PROPERTY_CODABAR_ENABLED, true);
        DEFAULT_BARCODE_READER_PROPS.put(BarcodeReader.PROPERTY_CODE_39_ENABLED, true);
        DEFAULT_BARCODE_READER_PROPS.put(BarcodeReader.PROPERTY_CODE_93_ENABLED, true);
        DEFAULT_BARCODE_READER_PROPS.put(BarcodeReader.PROPERTY_CODE_128_ENABLED, true);
        DEFAULT_BARCODE_READER_PROPS.put(BarcodeReader.PROPERTY_DATAMATRIX_ENABLED, true);
        DEFAULT_BARCODE_READER_PROPS.put(BarcodeReader.PROPERTY_EAN_8_ENABLED, true);
        DEFAULT_BARCODE_READER_PROPS.put(BarcodeReader.PROPERTY_EAN_13_ENABLED, true);
        DEFAULT_BARCODE_READER_PROPS.put(BarcodeReader.PROPERTY_MAXICODE_ENABLED, true);
        DEFAULT_BARCODE_READER_PROPS.put(BarcodeReader.PROPERTY_PDF_417_ENABLED, true);
        DEFAULT_BARCODE_READER_PROPS.put(BarcodeReader.PROPERTY_QR_CODE_ENABLED, true);
        DEFAULT_BARCODE_READER_PROPS.put(BarcodeReader.PROPERTY_RSS_ENABLED, true);
        DEFAULT_BARCODE_READER_PROPS.put(BarcodeReader.PROPERTY_RSS_EXPANDED_ENABLED, true);
        DEFAULT_BARCODE_READER_PROPS.put(BarcodeReader.PROPERTY_UPC_A_ENABLE, true);
        DEFAULT_BARCODE_READER_PROPS.put(BarcodeReader.PROPERTY_UPC_E_ENABLED, true);
    }


    public HoneywellReaderDelegate(@NonNull FlutterPlugin.FlutterPluginBinding binding) {
        applicationContext = binding.getApplicationContext();
        final MethodChannel methodChannel = new MethodChannel(binding.getBinaryMessenger(), "plugins.honeywell.com/reader");
        this.dartMessenger = new DartMessenger(applicationContext, methodChannel, new Handler(Looper.getMainLooper()));
    }

    public void init(boolean autoConnect, ReadingMode readerMode) {
        this.autoConnect = autoConnect;
        this.readingMode = readerMode;
        if (this.autoConnect) {
            if (this.readingMode.isBarcode()) {
                AidcManager.create(this.applicationContext, this);
            }
        }
    }

    public void dispose() {
        if (this.barcodeReader == null) {
            return;
        }
        this.barcodeReader.removeBarcodeListener(this);
        this.barcodeReader.release();
        this.barcodeReader.close();
        this.barcodeReader = null;
        if (this.aidcManager == null) {
            return;
        }
        this.aidcManager.close();
        this.aidcManager = null;
    }

    public void start() {
        if (this.barcodeReader == null) {
            return;
        }
        try {
            this.barcodeReader.claim();
        } catch (ScannerUnavailableException e) {
            Log.e(getClass().getSimpleName(), "Barcode Reader can not started...", e);
            // TODO translate
            dartMessenger.sendReaderErrorEvent("Barcode Reader can not started...");
        }
    }

    public void pause() {
        if (this.barcodeReader == null) {
            return;
        }
        this.barcodeReader.release();
    }

    public void setProperties(Map<String, Object> properties) {
        if (barcodeReader == null || properties == null || properties.isEmpty()) {
            return;
        }
        DEFAULT_BARCODE_READER_PROPS.putAll(properties);
        this.barcodeReader.setProperties(DEFAULT_BARCODE_READER_PROPS);
    }

    public void changeMode(ReadingMode readingMode) {
        this.readingMode = readingMode;
    }

    public void connect() {
        if (this.readingMode.isBarcode()) {
            if (barcodeReader == null) {
                AidcManager.create(this.applicationContext, this);
            }
        } else if (this.readingMode.isRfid()) {

        }
    }

    @Override
    public void onCreated(AidcManager aidcManager) {
        try {
            this.aidcManager = aidcManager;
            this.barcodeReader = aidcManager.createBarcodeReader();
            this.barcodeReader.addBarcodeListener(this);
            this.barcodeReader.setProperty(BarcodeReader.PROPERTY_TRIGGER_CONTROL_MODE, BarcodeReader.TRIGGER_CONTROL_MODE_AUTO_CONTROL);
            this.barcodeReader.setProperty(BarcodeReader.PROPERTY_DATA_PROCESSOR_LAUNCH_BROWSER, false);
            this.barcodeReader.setProperties(DEFAULT_BARCODE_READER_PROPS);
            start();
            dartMessenger.sendReaderStatusEvent(ReaderStatus.CONNECTED);
            Log.i(getClass().getSimpleName(), "Barcode Reader successfully created...");
        } catch (UnsupportedPropertyException | InvalidScannerNameException e) {
            Log.e(getClass().getSimpleName(), "Barcode Reader can not created...", e);
            // TODO
            dartMessenger.sendReaderErrorEvent("Barcode Reader can not created...");
        }
    }

    @Override
    public void onBarcodeEvent(BarcodeReadEvent event) {
        Log.i(getClass().getSimpleName(), "BarcodeReadEvent{data=" + event.getBarcodeData() + ", charset=" + event.getCharset() + ", codeId=" + event.getCodeId() + ", bounds=" + event.getBarcodeBounds() + "}");
        dartMessenger.sendTagReadEvent(event.getCodeId(), event.getBarcodeData());
    }

    @Override
    public void onFailureEvent(BarcodeFailureEvent event) {
        Log.i(getClass().getSimpleName(), "BarcodeFailureEvent{timestamp=" + event.getTimestamp() + "}");
        dartMessenger.sendReaderErrorEvent("Barcode read failure occurred...");
    }
}
