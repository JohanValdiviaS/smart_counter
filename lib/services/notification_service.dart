import 'package:flutter/material.dart';

class NotificationsService {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static showSnackBarLogin(String message) {
    const snackBar = SnackBar(
      content: Center(
        child: Text(
          'Las credenciales no son correctas',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
    messengerKey.currentState!.showSnackBar(snackBar);
  }

  static showSnackBarSignin(String message) {
    const snackBar = SnackBar(
      content: Center(
        child: Text(
          'Las credenciales ya están siendo utilizadas',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
    messengerKey.currentState!.showSnackBar(snackBar);
  }
}
