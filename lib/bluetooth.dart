import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothScreen extends StatefulWidget {
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  final FlutterBluePlus flutterBlue = FlutterBluePlus();
  List<ScanResult> scanResults = [];

  @override
  void initState() {
    super.initState();
    scanForDevices();
    // pedirPermisos().then((_) {
    //   // You can start scanning after permissions are granted
    //   scanForDevices();
    // });
  }

  Future<void> pedirPermisos() async {
    await [
      Permission.location,
      Permission.locationWhenInUse,
      Permission.bluetooth,
    ].request();
  }

  void scanForDevices() {
    FlutterBluePlus.startScan(timeout: Duration(seconds: 5));
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        if (!scanResults.any((element) => element.device.id == r.device.id)) {
          setState(() {
            scanResults.add(r);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            onPressed: scanForDevices,
            icon: Icon(Icons.bluetooth),
            label: Text("Buscar dispositivos"),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: scanResults.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(scanResults[index].device.advName),
                subtitle: Text(scanResults[index].hashCode.toString()),
              );
            },
          ),
        ),
      ],
    );
  }
}
