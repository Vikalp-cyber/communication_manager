# Communication Manager

A Flutter package that allows communication using both BLE and Bluetooth Classic .

## Features

- Scan BLE Devices
- Scan Classic Bluetooth Devices

## Getting Started

```dart
final bleManager = ConnectionManager(connectionType: ConnectionType.ble);
final classicManager = ConnectionManager(connectionType: ConnectionType.classic);

bleManager.scanDevices();
classicManager.scanDevices();
