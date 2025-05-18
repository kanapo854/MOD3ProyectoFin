import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:libreria/screens/admin_home_screen.dart';
import 'package:libreria/screens/cliente_home_screen.dart';
import 'register_screen.dart'; // Asegúrate de importar la pantalla de registro

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    User? user = userCredential.user;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      String role = userDoc.get('role');

      if (role == 'admin') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHomeScreen()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BookStoreScreen()));
      }
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al iniciar sesión: $e')));
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 195, 243, 223), 

      appBar: AppBar(title: Text('Iniciar Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController, 
              style: TextStyle(color: Color.fromARGB(255, 11, 59, 47)), 
              decoration: InputDecoration(labelText: 'Email',), 
            ),
            TextField(
              controller: _passwordController, 
              style: TextStyle(color: Color.fromARGB(255, 11, 59, 47)), 
              decoration: InputDecoration(labelText: 'Contraseña'), 
              obscureText: true
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login, child: Text('Ingresar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 11, 59, 47),
                foregroundColor: Colors.white
              ),
              ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text('¿No tienes una cuenta? Regístrate aquí', style: TextStyle(color: Color.fromARGB(255, 11, 59, 47))),
            ),
          ],
        ),
      ),
    );
  }
}