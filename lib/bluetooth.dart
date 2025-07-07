import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class BluetoothScreen extends StatefulWidget {
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  List<ScanResult> scanResults = [];

  @override
  void initState() {
    super.initState();
    pedirPermisos().then((_) async {
      bool locationEnabled = await Geolocator.isLocationServiceEnabled();
      if (!locationEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Por favor activa la ubicación')),
        );
        return;
      }
      scanForDevices();
    });
  }

  Future<void> pedirPermisos() async {
    await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
      Permission.locationWhenInUse,
    ].request();
  }

  void scanForDevices() {
    scanResults.clear();
    FlutterBluePlus.startScan(timeout: Duration(seconds: 5));
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        if (!scanResults.any((sr) => sr.device.remoteId == r.device.remoteId)) {
          setState(() {
            scanResults.add(r);
          });
        }
      }
    });
  }

  String obtenerNombreDispositivo(ScanResult r) {
    final advName = r.advertisementData.advName;
    final platformName = r.device.platformName;

    if (advName.isNotEmpty) return advName;
    if (platformName.isNotEmpty) return platformName;

    return "Dispositivo sin nombre";
  }

  Future<void> conectarDispositivo(BluetoothDevice device) async {
    try {
      if (await device.isDisconnected) {
        await device.connect();
        print("Conectado a ${device.remoteId.str}");


        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Conectado a ${device.remoteId.str}')),
        );
      }
    } catch (e) {
      print("Error al conectar: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al conectar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dispositivos Bluetooth")),
      body: ListView.builder(
        itemCount: scanResults.length,
        itemBuilder: (context, index) {
          final result = scanResults[index];
          final name = obtenerNombreDispositivo(result);

          return ListTile(
            title: Text(name),
            subtitle: Text(result.device.remoteId.str),
            onTap: () => conectarDispositivo(result.device),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: scanForDevices,
        child: Icon(Icons.bluetooth_searching),
      ),
    );
  }
}
