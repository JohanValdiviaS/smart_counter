// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:smart_counter/services/services.dart';
import 'package:smart_counter/providers/providers.dart';
import 'package:smart_counter/widgets/widgets.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Stack(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    TopWidget(),
                  ],
                ),
              ],
            ),
            const Positioned(
              top: 200,
              child: SizedBox(
                height: 170,
                child: Image(
                  image: AssetImage('assets/logo.png'),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Crear Cuenta",
              style: TextStyle(
                fontFamily: 'Myriad',
                fontSize: 32,
                fontWeight: FontWeight.w500,
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 10),
                ChangeNotifierProvider(
                  create: (_) => LoginFormProvider(),
                  child: _RegisterForm(),
                ),
              ],
            ),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
              style: ButtonStyle(
                overlayColor: WidgetStateProperty.all(
                  Colors.orangeAccent.withOpacity(0.1),
                ),
                shape: WidgetStateProperty.all(
                  const StadiumBorder(),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¿Ya tienes una cuenta?, ',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Inicia Sesión',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(117, 0, 206, 1),
                    ),
                  ),
                ],
              ),
            ),
            const Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    FooterWidget(),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              AuthTextFormField(
                hintText: 'usuario@gmail.com',
                labelText: 'Correo Electrónico',
                prefixIcon: Icons.alternate_email_sharp,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => loginForm.email = value,
                validator: (value) {
                  String pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp = RegExp(pattern);
                  return regExp.hasMatch(value ?? '')
                      ? null
                      : 'El valor ingresado no es correcto';
                },
              ),
              const SizedBox(height: 30),
              AuthTextFormField(
                hintText: '********',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: true,
                onChanged: (value) => loginForm.password = value,
                validator: (value) {
                  return (value != null && value.length >= 6)
                      ? null
                      : 'La contraseña debe ser de 6 caracteres o más';
                },
              ),
              const SizedBox(height: 30),
              MaterialButton(
                onPressed: loginForm.isLoading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();
                        final authService =
                            Provider.of<AuthService>(context, listen: false);
                        if (!loginForm.isValidForm()) return;
                        loginForm.isLoading = true;

                        final String? errorMessage = await authService
                            .createUser(loginForm.email, loginForm.password);

                        if (errorMessage == null) {
                          Navigator.pushReplacementNamed(context, 'home');
                        } else {
                          NotificationsService.showSnackBarSignin(errorMessage);
                          loginForm.isLoading = false;
                        }
                      },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                disabledColor: Colors.grey,
                elevation: 0,
                color: const Color.fromRGBO(117, 0, 206, 1),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  child: Text(
                    loginForm.isLoading ? 'Espere...' : 'Registrar',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
