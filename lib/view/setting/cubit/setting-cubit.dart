import 'dart:async';

import 'package:easacc/view/setting/cubit/setting-state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:wifi_scan/wifi_scan.dart';

class SettingCubit extends Cubit<SettingState> {
  SettingCubit() : super(SettingInitialState());

  final FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
  List<BluetoothDevice> _blueDevices = List.empty(growable: true);

  List<String> _allDevices = List.empty(growable: true);

  List<WiFiAccessPoint> _accessPoints = List.empty(growable: true);

  // List<WifiNetwork>? wifiDevices = List.empty(growable: true);
  // List<BluetoothDevice> allBlueDevices = List.empty(growable: true);
  // StreamSubscription<List<WiFiAccessPoint>>? subscription;
  bool shouldCheckCan = true;

  Future<void> initBluetooth() async {
    emit(BluSettingStateLoading());
    try {
      BluetoothState bluetoothState =
          await FlutterBluetoothSerial.instance.state;
      if (bluetoothState != BluetoothState.STATE_ON) {
        await FlutterBluetoothSerial.instance.requestEnable();
      }
      await blueStartScan();
    } on Exception catch (msg) {
      emit(BluSettingStateFailed(msg: "$msg"));
    }
  }

  Future<void> blueStartScan() async {
    // emit(BluSettingStateLoading());
    bluetooth.startDiscovery().listen(
          (device) {
            if (!_blueDevices
                .contains(BluetoothDevice(address: device.device.address))) {
              _blueDevices.add(device.device);
              _allDevices.add(device.device.name!);
            }
            emit(BluSettingStateSuccess(
                blueDevices: List.from(_blueDevices),
                combinedDevices: _allDevices));
            // print("{_blueDevices.length}");
          },
          onDone: () {
            emit(BluSettingStateFinished());
          },
          cancelOnError: true,
          onError: (msg) {
            emit(BluSettingStateFailed(
                msg: "Bluetooth discovery: ${msg.runtimeType}"));
          },
        );
  }

  Future<void> wifiStartScan() async {
    if (shouldCheckCan) {
      final can = await WiFiScan.instance.canStartScan();
      if (can != CanStartScan.yes) {
        emit(WifiSettingStateFailed(msg: "Wifi Permission Needed"));
        return;
      }
    }
    final result = await WiFiScan.instance.startScan();
  }

  Future<bool> canGetScannedResults() async {
    if (shouldCheckCan) {
      final can = await WiFiScan.instance.canGetScannedResults();
      if (can != CanGetScannedResults.yes) {
        emit(WifiSettingStateFailed(msg: "Cannot get wifi devices open device location : $can"));
        return false;
      }
      if (can == CanGetScannedResults.noLocationServiceDisabled) {
        emit(WifiSettingStateFailed(msg: "Open device location"));
        return false;
      }
    }
    return true;
  }

  Future<void> getWifiScannedResults() async {
    emit(WifiSettingStateLoading());
    wifiStartScan();
    try {
      if (await canGetScannedResults()) {
        final results = await WiFiScan.instance.getScannedResults();
        _accessPoints = results;
        _allDevices
            .addAll(results.map((wifi) => wifi.ssid ?? "Unknown WiFi Network"));
        emit(WifiSettingStateSuccess(
            wifiDevices: _accessPoints, combinedDevices: _allDevices));
      }
    } on Exception catch (msg) {
      emit(WifiSettingStateFailed(msg: "$msg"));
    }
  }

  void disposeBlueDevices() {
    bluetooth.cancelDiscovery();
    _accessPoints = [];
    _allDevices.clear();
    _blueDevices.clear();
  }
}
