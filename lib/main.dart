import 'package:flutter/material.dart';
import 'package:wireless_app_flutter/wifi.dart';
import 'services/permission_handler.dart';
import 'bluetooth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    iniciar();
  }

  Future<void> iniciar() async {
    await pedirPermisos();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wireless Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("NavWireless"),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.wifi), text: 'WiFi'),
                Tab(icon: Icon(Icons.bluetooth), text: 'Bluethooth'),
              ],
            ),
          ),
          body: (TabBarView(children: [WifiPage(), BluetoothScreen()])),
        ),
      ),
    );
  }
}
