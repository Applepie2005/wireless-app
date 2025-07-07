import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';


class BluetoothScreen extends StatefulWidget {
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  final FlutterBluePlus flutterBlue = FlutterBluePlus();
  List<BluetoothDevice> devices = [];

  @override
  void initState() {
    super.initState();
    scanForDevices();
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
        if (!devices.contains(r.device)) {
          setState(() {
            devices.add(r.device);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bluetooth Devices")),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(devices[index].advName),
            subtitle: Text(devices[index].hashCode.toString()),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: scanForDevices,
        child: Icon(Icons.bluetooth),
      ),
    );
  }
}