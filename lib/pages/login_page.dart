import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../appbar.dart';
import '../input.dart';
import '../scrollable_column.dart';

class LoginPage extends StatefulWidget {
  const LoginPage() : super();
  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMeChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Ingresar a tu cuenta"),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Form(
          key: _formKey,
          child: ScrollableColumn(
            children: [
              CustomInputField(
                keyboardType: TextInputType.emailAddress,
                hintText: "Ingrese su correo",
                controller: _emailController,
                validator: (String? email) {
                  if (email == null) {
                    return null;
                  }
                  bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
                  return emailValid ? null : "El correo no es valido";
                },
              ),
              SizedBox(height: 24),
              CustomInputField(
                keyboardType: TextInputType.visiblePassword,
                hintText: "Ingrese su contraseña",
                obscureText: true,
                controller: _passwordController,
                validator: (String? password) {
                  if (password == null) {
                    return null;
                  }
                  if (password.length < 6) {
                    return "Su contraseña es muy corta";
                  }
                },
              ),
              SizedBox(height: 24),
              CustomCheckbox(
                labelText: "Recordame",
                value: _rememberMeChecked,
                onChanged: (checked) => setState(() => _rememberMeChecked = checked ?? false),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                child: Text("Ingresar"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                      email: _emailController.value.text,
                      password: _passwordController.value.text,
                    )
                        .then((result) {
                      Navigator.of(context).pushNamedAndRemoveUntil('/main', (_) => false);
                    }).catchError((Object exception) {
                      if (exception is FirebaseAuthException) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Fallo al autenticar: ${exception.message}')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Hubo un erro para autenticar ${exception}')),
                        );
                      }
                    });
                  }
                },
              ),
              Expanded(
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "No cuento con una cuenta",
                    style: TextStyle(
                      color: Color(0xFFb8b8b8),
                    ),
                  ),
                  TextButton(
                    child: Text("Crear una"),
                    onPressed: () => {
                      Navigator.of(context).pushNamed("/register")
                    },
                  ),
                ],
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
