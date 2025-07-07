import 'package:wifi_iot/wifi_iot.dart';
import 'package:network_info_plus/network_info_plus.dart';

class WifiManager {
  static Future<List<WifiNetwork>> escanearRedes() async {
    return await WiFiForIoTPlugin.loadWifiList() ?? [];
  }

  static Future<bool> conectar(String ssid, String password) async {
    return await WiFiForIoTPlugin.connect(
      ssid,
      password: password,
      joinOnce: true,
      security: NetworkSecurity.WPA,
    );
  }

  static Future<String?> obtenerSSID() async {
    final info = NetworkInfo();
    return await info.getWifiName();
  }

  static Future<bool> estaConectado(String ssidEsperado) async {
    String? actual = await obtenerSSID();
    return actual?.replaceAll('"', '') == ssidEsperado;
  }
}