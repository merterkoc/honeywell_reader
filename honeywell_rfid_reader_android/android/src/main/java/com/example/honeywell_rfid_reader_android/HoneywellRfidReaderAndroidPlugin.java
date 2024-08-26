package com.example.honeywell_reader_android;

import static android.content.Context.RECEIVER_EXPORTED;
import static android.content.Context.RECEIVER_NOT_EXPORTED;

import android.Manifest;
import android.annotation.SuppressLint;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.IntentFilter;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;

import com.example.honeywell_reader_android.bluetooth.BluetoothDeviceInfo;
import com.example.honeywell_reader_android.constants.ChannelAddress;
import com.example.honeywell_reader_android.helper.observer.TagChangeBroadcastReceiver;
import com.example.honeywell_reader_android.helper.observer.TagInfo;
import com.example.honeywell_reader_android.messages.DartEventBroadcaster;
import com.example.honeywell_reader_android.messages.DartMessenger;
import com.example.honeywell_reader_android.messages.MyBluetoothDevice;
import com.example.honeywell_reader_android.messages.model.ConnectionStatus;
import com.honeywell.rfidservice.EventListener;
import com.honeywell.rfidservice.RfidManager;
import com.honeywell.rfidservice.TriggerMode;
import com.honeywell.rfidservice.rfid.OnTagReadListener;
import com.honeywell.rfidservice.rfid.RfidReader;
import com.honeywell.rfidservice.rfid.TagAdditionData;
import com.honeywell.rfidservice.rfid.TagReadData;
import com.honeywell.rfidservice.utils.ByteUtils;

import java.sql.DriverManager;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * HoneywellRfidReaderAndroidPlugin
 */
public class HoneywellRfidReaderAndroidPlugin implements FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {

    private boolean bluetoothAutoConnect = false;
    private MethodChannel channel;
    private DartMessenger dartMessenger;

    private DartEventBroadcaster dartEventBroadcaster;

    static EventChannel.EventSink eventSink;
    private EventChannel eventChannel;

    private final String[] mPermissions = new String[]{
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.WRITE_EXTERNAL_STORAGE,
    };

    private final boolean[] mPermissionGranted = new boolean[]{
            false, false
    };

    private final List<String> mRequestPermissions = new ArrayList<>();
    private static final int PERMISSION_REQUEST_CODE = 1;

    private RfidManager rfidManager;

    private TriggerMode currentTriggerMode = TriggerMode.RFID;

    private final List<BluetoothDeviceInfo> bluetoothDeviceList = new ArrayList<>();

    private long mPrevListUpdateTime;

    private BluetoothAdapter bluetoothAdapter;

    private final List<TagInfo> mTagDataList = new ArrayList<>();

    private final TagChangeBroadcastReceiver tagChangeBroadcastReceiver = new TagChangeBroadcastReceiver();


    @SuppressLint("UnspecifiedRegisterReceiverFlag")
    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), ChannelAddress.MAIN_CHANNEL);
        dartMessenger = new DartMessenger(flutterPluginBinding.getApplicationContext(), channel, new Handler(Looper.getMainLooper()));
        dartEventBroadcaster = new DartEventBroadcaster(flutterPluginBinding.getApplicationContext(), new Handler(Looper.getMainLooper()));

        eventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), ChannelAddress.ON_TAG_READ);
        eventChannel.setStreamHandler(this);

        IntentFilter filter = new IntentFilter("action.TAG_CHANGE");
        filter.addAction("action.TAG_CHANGE");
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            flutterPluginBinding.getApplicationContext().registerReceiver(tagChangeBroadcastReceiver, filter, RECEIVER_EXPORTED);
            flutterPluginBinding.getApplicationContext().registerReceiver(tagChangeBroadcastReceiver, filter, RECEIVER_NOT_EXPORTED);
        }

        channel.setMethodCallHandler(this);
        bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
        RfidManager.create(flutterPluginBinding.getApplicationContext(), new RfidManager.CreatedCallback() {
            @Override
            public void onCreated(RfidManager rfid) {
                rfidManager = rfid;
                rfidManager.addEventListener(mEventListener);

            }
        });
    }

    private final BluetoothAdapter.LeScanCallback mLeScanCallback =
            new BluetoothAdapter.LeScanCallback() {
                @Override
                public void onLeScan(BluetoothDevice device, int rssi, byte[] scanRecord) {
                    if (device.getName() != null && !device.getName().isEmpty()) {
                        synchronized (bluetoothDeviceList) {
                            boolean newDevice = true;

                            for (BluetoothDeviceInfo info : bluetoothDeviceList) {
                                if (device.getAddress().equals(info.dev.getAddress())) {
                                    newDevice = false;
                                    info.rssi = rssi;
                                }
                            }

                            if (newDevice) {
                                bluetoothDeviceList.add(new BluetoothDeviceInfo(device, rssi));
                            }

                            long cur = System.currentTimeMillis();

                            if (newDevice || cur - mPrevListUpdateTime > 500) {
                                mPrevListUpdateTime = cur;

                                dartEventBroadcaster.sendBluetoothDeviceFoundEvent(new MyBluetoothDevice(device.getName(), device.getAddress(), String.valueOf(rssi)));
                                if (bluetoothAutoConnect && device.getName() != null && device.getName().equals("IH45")) {
                                    bluetoothAdapter.stopLeScan(mLeScanCallback);
                                    rfidManager.connect(device.getAddress());
                                    if (rfidManager.getReader() == null) {
                                        dartMessenger.sendReaderErrorEvent("Reader not connected");
                                        Log.d("notConnected", "notConnected");
                                    }
                                }
                            }
                        }
                    }
                }
            };


    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("scanBluetoothDevices")) {
            try {
                bluetoothAutoConnect = Boolean.TRUE.equals(call.arguments());
                if (bluetoothAdapter.isEnabled()) {
                    bluetoothAdapter.startLeScan(mLeScanCallback);
                    result.success(true);
                } else {
                    result.error("110", "Bluetooth not enabled", "Bluetooth not enabled");
                }
            } catch (SecurityException e) {
                result.error("Error", e.getMessage(), null);
            }
        } else if (call.method.equals("disconnectDevice")) {
            rfidManager.disconnect();
            result.success(true);
        } else if (call.method.equals("createReader")) {
            rfidManager.createReader();
            result.success(true);
        } else if (call.method.equals("disableScanBluetoothDevices")) {
            bluetoothAdapter.stopLeScan(mLeScanCallback);
            result.success(true);
        } else if (call.method.equals("readStart")) {
            startRead(result);
            result.success(true);
        } else if (call.method.equals("readStop")) {
            stopRead(result);
            result.success(true);
        } else if (call.method.equals("bluetoothState")) {
            result.success(bluetoothAdapter.isEnabled());
        } else if (call.method.equals("bluetoothEnable")) {
            bluetoothAdapter.enable();
            result.success(true);
        } else if (call.method.equals("bluetoothDisable")) {
            bluetoothAdapter.disable();
            result.success(true);
        } else if (call.method.equals("checkConnection")) {
            result.success(rfidManager.isConnected());
        } else if (call.method.equals("connectDevice")) {
            String deviceAddress = call.arguments();
            if (rfidManager.isConnected()) {
                rfidManager.disconnect();
            } else if (!rfidManager.connect(deviceAddress)) {
                result.error("Error", "Device not found", null);
            }
            result.success(true);
        } else if (call.method.equals("connectUsbDevice")) {
            rfidManager.connect(null);
            result.success(true);
        } else if (call.method.equals("disconnectUsbDevice")) {
            rfidManager.disconnect();
            result.success(true);
        } else if (call.method.equals("setTriggerMode")) {
            String mode = call.arguments();
            if (Objects.equals(mode, "RFID")) {
                currentTriggerMode = TriggerMode.RFID;
                rfidManager.setTriggerMode(TriggerMode.RFID);
            } else if (Objects.equals(mode, "BARCODE")) {
                currentTriggerMode = TriggerMode.BARCODE;
                rfidManager.setTriggerMode(TriggerMode.BARCODE);
            } else {
                result.error("Error", "Invalid trigger mode", null);
            }
            Log.d("setTriggerMode", "setTriggerMode completed");
            result.success(true);
        } else {
            result.notImplemented();
        }
    }

    private boolean isReaderAvailable() {
        return rfidManager.getReader() != null && rfidManager.getReader().available();
    }

    private void startRead(Result result) {
        if (!isReaderAvailable()) {
            RfidReader reader = rfidManager.getReader();
            if (reader == null) {
                if (result != null) {
                    result.error("Reader is null'", "Reader is null'", null);
                }
                return;
            }
            boolean b = rfidManager.readerAvailable();
            Log.d("readerAvailable", "readerAvailable: " + b);
            if (!b) {
                if (result != null) {
                    result.error("Reader not available", "Reader not available", null);
                }
                return;
            }
        }
        synchronized (mTagDataList) {
            mTagDataList.clear();
        }
        rfidManager.getReader().setOnTagReadListener(dataListener);
        rfidManager.getReader().read(TagAdditionData.NONE);
        dartMessenger.sendRfidReadStatusEvent(true);
        Log.d("startRead", "startRead completed");
    }

    private void stopRead(Result result) {
        if (!isReaderAvailable()) {
            if (result != null) {
                result.error("Reader not available", "Reader not available", null);
            }
            return;
        }
        synchronized (mTagDataList) {
            mTagDataList.clear();
        }
        rfidManager.getReader().removeOnTagReadListener(dataListener);
        rfidManager.getReader().stopRead();
        dartMessenger.sendRfidReadStatusEvent(false);
    }

    private boolean isBluetoothPermissionGranted() {

        for (int i = 0; i < mPermissions.length; ++i) {
            if (Manifest.permission.ACCESS_FINE_LOCATION.equals(mPermissions[i])) {
                return mPermissionGranted[i];
            }
        }
        return false;
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    }


    private final EventListener mEventListener = new EventListener() {

        @Override
        public void onReadRemoteRssi(BluetoothDevice bluetoothDevice, int i) {
            EventListener.super.onReadRemoteRssi(bluetoothDevice, i);
            Log.d("onReadRemoteRssi", "onReadRemoteRssi");
        }

        @Override
        public void onDeviceConnected(Object o) {
            Log.d("onDeviceConnected", "onDeviceConnected");
            dartMessenger.sendRfidConnectionStatusEvent(ConnectionStatus.CONNECTED);
        }

        @Override
        public void onDeviceDisconnected(Object o) {
            Log.d("onDeviceDisconnected", "onDeviceDisconnected");
            dartMessenger.sendRfidConnectionStatusEvent(ConnectionStatus.DISCONNECTED);
        }

        @Override
        public void onUsbDeviceAttached(Object o) {
            Log.d("onUsbDeviceAttached", "onUsbDeviceAttached");
        }

        @Override
        public void onUsbDeviceDetached(Object o) {
            Log.d("onUsbDeviceDetached", "onUsbDeviceDetached");
        }

        @Override
        public void onReaderCreated(boolean b, final RfidReader rfidReader) {
            Log.d("onReaderCreated", "onReaderCreated");
        }

        @Override
        public void onRfidTriggered(boolean b) {

            Log.d("onRfidTriggered", "onRfidTriggered");
            if (b) {
                startRead(null);
            } else {
                stopRead(null);
            }

        }

        @Override
        public void onTriggerModeSwitched(TriggerMode triggerMode) {
            Log.d("onTriggerModeSwitched", "onTriggerModeSwitched");
            currentTriggerMode = triggerMode;
        }

        @Override
        public void onReceivedFindingTag(int i) {

        }
    };


    private final OnTagReadListener dataListener = new OnTagReadListener() {
        @Override
        public void onTagRead(final TagReadData[] t) {
            synchronized (mTagDataList) {
                for (TagReadData trd : t) {
                    String epc = trd.getEpcHexStr();

                    Log.d("tagReadNative: ", "onTagRead");
                    Log.d("tagReadNative: ", epc);
                    if (true) {
                        epc += ByteUtils.bytes2HexStr(trd.getAdditionData());
                    }
                    boolean doUpdate = true;
                    for (TagInfo tagInfo : mTagDataList) {
                        if (true) {
                            String key = tagInfo.tagReadData.getEpcHexStr()
                                    + ByteUtils.bytes2HexStr(tagInfo.tagReadData.getAdditionData());
                            if (key.equals(epc)) {
                                ++tagInfo.count;
                                doUpdate = false;
                                break;
                            }
                        } else {
                            if (tagInfo.tagReadData.getEpcHexStr().equals(trd.getEpcHexStr())) {
                                ++tagInfo.count;
                                doUpdate = false;
                                break;
                            }
                        }
                    }
                    if (doUpdate) {
                        TagInfo tagInfo = new TagInfo();
                        tagInfo.tagReadData = trd;
                        tagInfo.count = 1;
                        mTagDataList.add(tagInfo);
                        new Handler(Looper.getMainLooper()).post(new Runnable() {
                            @Override
                            public void run() {
                                if (eventSink != null) {
                                    dartEventBroadcaster.sendRfidReadEvent(tagInfo.tagReadData.getEpcHexStr());
                                }
                            }
                        });
                    }
                }
            }
        }
    };

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        try {
            eventSink = events;
            dartEventBroadcaster.setEventSink(eventSink);

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void onCancel(Object arguments) {
        try {
            eventSink = null;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
