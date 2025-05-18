
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screens/login_screen.dart';

Future<void> ensureAdminExists() async {
  QuerySnapshot adminQuery = await FirebaseFirestore.instance
      .collection('users')
      .where('role', isEqualTo: 'admin')
      .get();

  if (adminQuery.docs.isEmpty) {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: 'admin@libreria.com',
      password: 'admin123',
    ).then((UserCredential result) {
      FirebaseFirestore.instance.collection('users').doc(result.user!.uid).set({
        'uid': result.user!.uid,
        'email': 'admin@libreria.com',
        'name': 'Administrador',
        'role': 'admin',
        'estado': 'A',
        'createdAt': DateTime.now().toIso8601String(),
      });
    });
  }
}

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Verificar si el administrador ya existe antes de iniciar la app
  await ensureAdminExists();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
          bodySmall: TextStyle(color: Colors.black),
        ),
        primaryColor: const Color.fromARGB(255, 186, 198, 199),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 11, 59, 47),
          foregroundColor: Colors.white,
        ),
      ),
      title: 'Libreria App',
      home: LoginScreen(),
    );
  }
}
