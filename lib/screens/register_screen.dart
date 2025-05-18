import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libreria/screens/login_screen.dart';
import 'package:libreria/services/auth_service.dart'; // Asegúrate de importar tu servicio de autenticación

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final AuthService _authService = AuthService();

  void _registerUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String name = nameController.text.trim();

    User? user = await _authService.registerUser(email, password, name);
    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario registrado exitosamente')),
      );
        Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      });

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar usuario')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 195, 243, 223), 
      appBar: AppBar(title: Text('Registro de Usuario')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController, 
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 11, 59, 47),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 11, 59, 47))
                )
                )
            ),
            TextField(
              controller: passwordController, 
              decoration: InputDecoration(
                labelText: 'Contraseña',
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 11, 59, 47),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 11, 59, 47))
                )
              ), 
              obscureText: true
            ),
            TextField(
              controller: nameController, 
              decoration: InputDecoration(
                labelText: 'Nombre',
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 11, 59, 47),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 11, 59, 47))
                )
              )
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registerUser, 
              child: Text('Registrarse'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 11, 59, 47),
                foregroundColor: Colors.white
              ),
            ),
          ],
        ),
      ),
    );
  }
}