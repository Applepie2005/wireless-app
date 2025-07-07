import 'package:permission_handler/permission_handler.dart';

Future<void> pedirPermisos() async {
  await [
    Permission.location,
    Permission.locationWhenInUse,
    Permission.bluetooth
  ].request();
}