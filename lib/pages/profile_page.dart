import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_counter/providers/providers.dart';
import 'package:smart_counter/services/services.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 150,
            child: Center(
              child: Image(
                image: AssetImage('assets/logo.png'),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'Bienvenido:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Text(
              '\n${user?.email ?? 'Desconocido'}', // Mostrar el correo electrónico del usuario
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
               Navigator.pushReplacementNamed(context, 'home');// Esto retrocede a la página anterior
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(151, 75, 209, 1),
            ),
            child: const Text(
              'Volver',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              authService.logout();
              Navigator.pushReplacementNamed(context, 'login');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              'Cerrar sesión',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
