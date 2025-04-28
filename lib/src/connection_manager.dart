import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart'
    as classic;
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as ble;
import 'connection_type.dart';
import 'device.dart';

class ConnectionManager {
  final ConnectionType connectionType;

  ConnectionManager({required this.connectionType});

  Future<List<Device>> scanDevices() async {
    List<Device> devices = [];

    if (connectionType == ConnectionType.ble) {
      // BLE Scanning
      await ble.FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
      await Future.delayed(
          Duration(seconds: 4)); // Wait for scanning to complete
      final scanResults = await ble.FlutterBluePlus.scanResults.first;
      for (var result in scanResults) {
        devices.add(Device(
            name: result.device.platformName.isNotEmpty
                ? result.device.platformName
                : "Unknown BLE Device",
            id: result.device.remoteId.str));
      }
      await ble.FlutterBluePlus.stopScan();
    } else if (connectionType == ConnectionType.classic) {
      // Classic Bluetooth Discovery
      bool? isEnabled = await classic.FlutterBluetoothSerial.instance.isEnabled;
      if (isEnabled == true) {
        final bondedDevices =
            await classic.FlutterBluetoothSerial.instance.getBondedDevices();
        for (var device in bondedDevices) {
          devices.add(Device(
              name: device.name ?? "Unknown Classic Device",
              id: device.address));
        }
      }
    }

    return devices;
  }
}
