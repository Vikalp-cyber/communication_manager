import 'package:flutter/material.dart';
import 'package:communication_manager/communication_manager.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Communication Manager Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ConnectionManager bleManager =
      ConnectionManager(connectionType: ConnectionType.ble);
  final ConnectionManager classicManager =
      ConnectionManager(connectionType: ConnectionType.classic);

  List<Device> devices = [];
  String selected = 'BLE';

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    await [
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.locationWhenInUse,
    ].request();
  }

  Future<void> scanDevices() async {
    List<Device> foundDevices = [];
    if (selected == 'BLE') {
      foundDevices = await bleManager.scanDevices();
    } else {
      foundDevices = await classicManager.scanDevices();
    }
    setState(() {
      devices = foundDevices;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Communication Manager Example'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                value: selected,
                onChanged: (value) {
                  setState(() {
                    selected = value!;
                  });
                },
                items: ['BLE', 'Classic'].map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: scanDevices,
                child: const Text('Scan'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices[index];
                return ListTile(
                  title: Text(device.name),
                  subtitle: Text(device.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
