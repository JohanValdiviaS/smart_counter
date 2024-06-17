// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_counter/pages/pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _currentUser;

  String formattedDate = '';
  double userMoney = 0.0;
  double lastExpenseAmount = 0.0;
  String lastExpenseDescription = '';
  double goalAmount = 0.0; // Variable para la meta actual
  double savedAmount = 0.0; // Variable para el monto ahorrado
  String goalName = ''; // Variable para el nombre de la meta
  List<Map<String, dynamic>> expenses = [];

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser!;
    formattedDate = _getFormattedDate();

    _loadUserData();
    _loadLastExpense();
    _loadGoalData(); // Cargar datos de la meta al iniciar la página
  }

  Future<void> _loadGoalData() async {
    DocumentSnapshot goalDoc =
        await _firestore.collection('users').doc(_currentUser.uid).get();
    setState(() {
      goalAmount = goalDoc.get('goalAmount') ?? 0.0;
      savedAmount = goalDoc.get('savedAmount') ?? 0.0;
      goalName = goalDoc.get('goalName') ?? '';
    });
  }

  Future<void> _loadUserData() async {
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(_currentUser.uid).get();
    setState(() {
      userMoney = userDoc.get('money') ?? 0.0;
      goalAmount = userDoc.get('goalAmount') ?? 0.0;
      savedAmount = userDoc.get('savedAmount') ?? 0.0;
      goalName = userDoc.get('goalName') ?? '';
    });
  }

  Future<void> _loadLastExpense() async {
    QuerySnapshot expenseSnapshot = await _firestore
        .collection('users')
        .doc(_currentUser.uid)
        .collection('expenses')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (expenseSnapshot.docs.isNotEmpty) {
      setState(() {
        lastExpenseAmount = expenseSnapshot.docs.first.get('amount');
        lastExpenseDescription = expenseSnapshot.docs.first.get('description');
      });
    }
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final formatter = DateFormat('EEEE d', 'es_ES');
    return formatter.format(now);
  }

  void _initializeUserData(User user) async {
    try {
      // Crea un documento para el usuario en Firestore
      DocumentReference userDocRef =
          _firestore.collection('users').doc(user.uid);

      // Establece los datos iniciales del usuario
      await userDocRef.set({
        'money': 0.0, // Inicializa el dinero en 0
        'expenses': [], // Inicializa una lista vacía para los gastos
      });

      // Actualiza el estado local con los datos iniciales
      setState(() {
        userMoney = 0.0;
        expenses = [];
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error al inicializar datos de usuario: $e');
      }
      rethrow; // Lanza una excepción para manejar el error donde sea necesario
    }
  }

  void _showAddGoalDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar Nueva Meta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration:
                    const InputDecoration(labelText: 'Nombre de la Meta'),
              ),
              TextField(
                controller: amountController,
                decoration:
                    const InputDecoration(labelText: 'Monto a Alcanzar'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                String goalName = nameController.text;
                double goalAmount = double.parse(amountController.text);

                // Guardar la nueva meta en Firestore
                await _firestore.collection('users').doc(_currentUser.uid).set({
                  'goalName': goalName,
                  'goalAmount': goalAmount,
                  'savedAmount': 0.0,
                });

                setState(() {
                  this.goalName = goalName;
                  this.goalAmount = goalAmount;
                  savedAmount = 0.0;
                });

                Navigator.of(context).pop();
              },
              child: const Text('Agregar Meta'),
            ),
          ],
        );
      },
    );
  }

  void _showAddMoneyDialog() {
    TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar Dinero a la Meta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                decoration:
                    const InputDecoration(labelText: 'Cantidad a Añadir'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                double amountToAdd = double.parse(amountController.text);

                // Actualizar el monto ahorrado y el porcentaje de avance
                double newSavedAmount = savedAmount + amountToAdd;

                // Actualizar los datos en Firestore
                await _firestore
                    .collection('users')
                    .doc(_currentUser.uid)
                    .update({
                  'savedAmount': newSavedAmount,
                });

                setState(() {
                  savedAmount = newSavedAmount;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Se añadieron \$${amountToAdd.toStringAsFixed(2)} a la meta'),
                  ),
                );

                Navigator.of(context).pop();
              },
              child: const Text('Agregar Dinero'),
            ),
          ],
        );
      },
    );
  }

  void _showAddExpenseDialog() {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    String transactionType = 'Gasto'; // Por defecto, se selecciona gasto

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar Gasto o Ingreso'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: transactionType,
                onChanged: (String? newValue) {
                  setState(() {
                    transactionType = newValue!;
                  });
                },
                items: <String>['Gasto', 'Ingreso']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Monto'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                double amount = double.tryParse(amountController.text) ?? 0.0;
                String description = descriptionController.text;

                // Verificar si el documento del usuario existe antes de agregar la transacción
                DocumentSnapshot userDoc = await _firestore
                    .collection('users')
                    .doc(_currentUser.uid)
                    .get();

                if (!userDoc.exists) {
                  // Si el documento del usuario no existe, inicializarlo
                  _initializeUserData(_currentUser);
                }

                // Determinar si es un gasto o ingreso
                if (transactionType == 'Gasto') {
                  // Guardar el gasto en Firestore
                  await _firestore
                      .collection('users')
                      .doc(_currentUser.uid)
                      .collection('expenses')
                      .add({
                    'amount': -amount, // Monto negativo para gastos
                    'description': description,
                    'timestamp': Timestamp.now(),
                  });

                  // Actualizar el dinero del usuario para gastos
                  double newMoney = userMoney - amount;
                  await _firestore
                      .collection('users')
                      .doc(_currentUser.uid)
                      .update({'money': newMoney});

                  // Actualizar la última transacción
                  setState(() {
                    lastExpenseAmount = amount;
                    lastExpenseDescription = description;
                    userMoney = newMoney;
                  });
                } else {
                  // Guardar el ingreso en Firestore
                  await _firestore
                      .collection('users')
                      .doc(_currentUser.uid)
                      .collection('expenses')
                      .add({
                    'amount': amount, // Monto positivo para ingresos
                    'description': description,
                    'timestamp': Timestamp.now(),
                  });

                  // Actualizar el dinero del usuario para ingresos
                  double newMoney = userMoney + amount;
                  await _firestore
                      .collection('users')
                      .doc(_currentUser.uid)
                      .update({'money': newMoney});

                  // Actualizar la última transacción
                  setState(() {
                    lastExpenseAmount = amount;
                    lastExpenseDescription = description;
                    userMoney = newMoney;
                  });
                }

                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteExpenseDialog() {
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Gasto o Ingreso'),
          content: TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
                labelText: 'Descripción del gasto o ingreso'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                String description = descriptionController.text;

                // Buscar y eliminar la transacción de Firestore
                QuerySnapshot expenseSnapshot = await _firestore
                    .collection('users')
                    .doc(_currentUser.uid)
                    .collection('expenses')
                    .where('description', isEqualTo: description)
                    .get();

                if (expenseSnapshot.docs.isNotEmpty) {
                  // Determinar si es un gasto o ingreso
                  double amountToDelete =
                      expenseSnapshot.docs.first.get('amount');
                  bool isExpense = amountToDelete <
                      0; // Si el monto es negativo, es un gasto

                  // Eliminar la transacción
                  await expenseSnapshot.docs.first.reference.delete();

                  // Actualizar el dinero del usuario
                  if (isExpense) {
                    // Restar el monto si es un gasto
                    double newMoney = userMoney +
                        amountToDelete.abs(); // Invertir el signo para sumar
                    await _firestore
                        .collection('users')
                        .doc(_currentUser.uid)
                        .update({'money': newMoney});

                    setState(() {
                      userMoney = newMoney;
                    });
                  } else {
                    // Sumar el monto si es un ingreso
                    double newMoney = userMoney -
                        amountToDelete; // Invertir el signo para restar
                    await _firestore
                        .collection('users')
                        .doc(_currentUser.uid)
                        .update({'money': newMoney});

                    setState(() {
                      userMoney = newMoney;
                    });
                  }

                  // Cerrar el diálogo
                  Navigator.of(context).pop();
                } else {
                  // Mostrar un mensaje de error si no se encuentra la transacción
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No se encontró el gasto o ingreso'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0D6F6),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 120,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Image(
                      image: AssetImage('assets/logo.png'),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFCFCAF0),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mi dinero - $formattedDate',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.black,
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfilePage(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$ $userMoney',
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Último gasto registrado',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(lastExpenseDescription),
                        Text(
                          '- \$ $lastExpenseAmount',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Meta actual :',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '\$ ${goalAmount.toStringAsFixed(2)}', // Mostrar el monto de la meta
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              goalName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${(savedAmount / goalAmount * 100).toStringAsFixed(0)}%', // Calcular y mostrar el porcentaje de avance
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Icon(Icons.show_chart, color: Colors.black),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            if (goalAmount == 0.0) {
                              _showAddGoalDialog();
                            } else {
                              _showAddMoneyDialog();
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const ActionButton(
                    icon: Icons.history,
                    label: 'Historial',
                    route: 'history',
                  ),
                  ActionButton(
                    icon: Icons.add,
                    label: 'Agregar',
                    onPressed: _showAddExpenseDialog,
                  ),
                  ActionButton(
                    icon: Icons.delete,
                    label: 'Eliminar',
                    onPressed: _showDeleteExpenseDialog,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16.0),
                child: FutureBuilder<QuerySnapshot>(
                  future: _firestore
                      .collection('users')
                      .doc(_currentUser.uid)
                      .collection('expenses')
                      .orderBy('timestamp', descending: true)
                      .limit(5)
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Text('No hay gastos registrados');
                    }

                    List<Map<String, dynamic>> expenses =
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      return {
                        'amount': document['amount'],
                        'description': document['description'],
                        'timestamp': document['timestamp'],
                      };
                    }).toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Últimos gastos',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: expenses.length,
                          itemBuilder: (BuildContext context, int index) {
                            Map<String, dynamic> expense = expenses[index];
                            DateTime expenseDate =
                                (expense['timestamp'] as Timestamp).toDate();
                            String formattedExpenseDate =
                                DateFormat.yMMMd().format(expenseDate);

                            return ListTile(
                              title: Text(expense['description']),
                              subtitle: Text(
                                '- \$ ${expense['amount']} • $formattedExpenseDate',
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final String? route;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
    this.route,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (route != null) {
          Navigator.pushNamed(context, route!);
        } else if (onPressed != null) {
          onPressed!();
        }
      },
      child: Column(
        children: [
          Icon(
            icon,
            size: 36,
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}
