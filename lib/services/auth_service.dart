import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  User? get currentUser => _auth.currentUser;

  Future<String?> createUser(String email, String password) async {
    try {
      // Crear usuario en Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Escribir el UID en el almacenamiento seguro
      await _secureStorage.write(key: 'uid', value: userCredential.user!.uid);

      // Inicializar datos adicionales en Firestore para el nuevo usuario
      await _initializeUserData(userCredential.user!);

      return null; // Éxito, no hay error
    } catch (e) {
      return e.toString(); // Devuelve el mensaje de error
    }
  }

  Future<void> _initializeUserData(User user) async {
    try {
      // Crea un documento para el usuario en Firestore
      DocumentReference userDocRef =
          _firestore.collection('users').doc(user.uid);

      // Establece los datos iniciales del usuario
      await userDocRef.set({
        'money': 0.0, // Por ejemplo, inicializa el dinero en 0
        'expenses': [], // Una lista vacía para los gastos
      });

      // Opcionalmente, puedes agregar más campos según tus necesidades
    } catch (e) {
      rethrow; // Lanza una excepción para manejar el error donde sea necesario
    }
  }

  Future<String?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _secureStorage.write(key: 'uid', value: userCredential.user!.uid);
      return null; // Éxito, no hay error
    } catch (e) {
      return e.toString(); // Devuelve el mensaje de error
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _secureStorage.delete(key: 'uid');
  }

  Future<String?> getCurrentUserId() async {
    return await _secureStorage.read(key: 'uid');
  }

  Future<String> redToken() async {
    return await _secureStorage.read(key: 'token') ?? '';
  }
}
