import 'package:flutter/material.dart';
import 'package:smart_counter/providers/providers.dart';
import 'package:smart_counter/services/auth_service.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 15),
              Text(
                "Historial",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 15),
            ],
          ),
          const SizedBox(height: 15),
          const SizedBox(
            height: 250,
            child: Center(
              child: Image(
                image: AssetImage('assets/obras.png'),
              ),
            ),
          ),
          const SizedBox(height: 15),
          const Padding(
            padding: EdgeInsets.only(left: 75, right: 75),
            child: Text(
              "Estamos trabajando para darte una mejor experiencia, por favor ten paciencia ",
              style: TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            alignment: Alignment.center,
            width: 110, // Tamaño del contenedor
            height: 110,
            decoration: const BoxDecoration(
              shape: BoxShape.circle, // Forma circular
              color: Color.fromARGB(255, 39, 39, 39), // Color del círculo
            ),
            child: const Center(
              child: Icon(
                Icons.warning_amber_rounded,
                size: 80,
                color: Colors.amber, // Color del icono
              ),
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(
                  context, 'home'); // Esto retrocede a la página anterior
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(151, 75, 209, 1),
            ),
            child: const Text(
              'Volver',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
