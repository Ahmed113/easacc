import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:wifi_scan/wifi_scan.dart';
// import 'package:wifi_scan/wifi_scan.dart';
// import 'package:wifi_scan/wifi_scan.dart';

abstract class SettingState{}
class SettingInitialState extends SettingState{}
class BluSettingStateLoading extends SettingState{}
class BluSettingStateSuccess extends SettingState{
  BluSettingStateSuccess({this.blueDevices, this.combinedDevices});
  List<BluetoothDevice>? blueDevices;
  List<String>? combinedDevices;
  // bool isInitBlue;

}
class BluSettingStateFinished extends SettingState{}
class BluSettingStateFailed extends SettingState{
  BluSettingStateFailed({this.msg});
  String? msg;
}

class WifiSettingStateLoading extends SettingState{}
class WifiSettingStateSuccess extends SettingState{
  WifiSettingStateSuccess({this.wifiDevices, this.combinedDevices});
  List<WiFiAccessPoint>? wifiDevices;
  List<String>? combinedDevices;
  // bool isInitBlue;
}
class WifiSettingStateFinished extends SettingState{}
class WifiSettingStateFailed extends SettingState{
  WifiSettingStateFailed({this.msg});
  String? msg;
}

