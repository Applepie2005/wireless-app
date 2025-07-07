import 'package:flutter/material.dart';
import 'services/wifi_service.dart';
import 'wifi_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wi-Fi Control App',
      home: WifiPage(),
    );
  }
}

class WifiPage extends StatefulWidget {
  @override
  _WifiPageState createState() => _WifiPageState();
}

class _WifiPageState extends State<WifiPage> {
  List redes = [];
  String? conectadoA;
  String password = "";

  @override
  void initState() {
    super.initState();
    iniciar();
  }

  Future<void> iniciar() async {
    await pedirPermisos();
    await escanear();
    await verificarConexion();
  }

  Future<void> escanear() async {
    final resultado = await WifiManager.escanearRedes();
    setState(() {
      redes = resultado;
    });
  }

  Future<void> verificarConexion() async {
    final ssid = await WifiManager.obtenerSSID();
    setState(() {
      conectadoA = ssid;
    });
  }

  void conectar(String ssid) async {
    bool ok = await WifiManager.conectar(ssid, password);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? "Conectado" : "Fallo al conectar")),
    );
    if (ok) await verificarConexion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Control Wi-Fi")),
      body: Column(
        children: [
          if (conectadoA != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Conectado a: $conectadoA"),
            ),
          TextField(
            decoration: const InputDecoration(labelText: "Contraseña"),
            onChanged: (val) => password = val,
            obscureText: true,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: redes.length,
              itemBuilder: (_, i) {
                final red = redes[i];
                return ListTile(
                  title: Text(red.ssid ?? "Sin nombre"),
                  subtitle: Text("Señal: ${red.level}"),
                  trailing: ElevatedButton(
                    onPressed: () => conectar(red.ssid ?? ""),
                    child: const Text("Conectar"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
