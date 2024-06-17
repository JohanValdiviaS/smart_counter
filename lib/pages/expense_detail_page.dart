import 'package:flutter/material.dart';

class ExpenseDetailsPage extends StatelessWidget {
  //final String label;
  //final String amount;

  const ExpenseDetailsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Gasto'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 150,
              child: Center(
                child: Image(
                  image: AssetImage('assets/logo.png'),
                ),
              ),
            ),
            Center(
              child: Text("Historial"),
            ),
          ],
        ),
      ),
    );
  }
}
