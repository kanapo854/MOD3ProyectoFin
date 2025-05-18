import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:libreria/repositories/totalRepository.dart';
import 'package:libreria/screens/lista_libro_screen.dart';
import 'package:libreria/screens/login_screen.dart';
import 'package:libreria/screens/register_book_screen.dart';
import 'package:libreria/screens/users_screen.dart';
import 'package:libreria/screens/transactions_screen.dart';
import 'package:libreria/screens/transaction_chart_screen.dart'; // Nueva pantalla

class AdminHomeScreen extends StatelessWidget {
  final TotalRepository _totalRepository = TotalRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
        actions: [
          PopupMenuButton<String>(
            offset: Offset(0, 50),
            onSelected: (value) {
              if (value == 'Registrar Libro') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterBookScreen()));
              } else if (value == 'Ver Usuarios') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UsersScreen()));
              } else if (value == 'Ver Transacciones') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionListScreen()));
              } else if (value == 'Ver Libros') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => BookListScreen()));
              } else if (value == 'Ver Gráfica de Transacciones') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionChartScreen())); // Nueva opción
              } else if (value == 'Cerrar Sesión') {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(value: 'Ver Usuarios', child: Text('Usuarios')),
              PopupMenuItem(value: 'Ver Transacciones', child: Text('Transacciones')),
              PopupMenuItem(value: 'Ver Libros', child: Text('Libros')),
              //PopupMenuItem(value: 'Ver Gráfica de Transacciones', child: Text('Ver Gráfica de Transacciones')), // Nueva opción
              PopupMenuItem(value: 'Cerrar Sesión', child: Text('Cerrar Sesión'))
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8), // Ajusta separación
            child: FutureBuilder<double>(
              future: _totalRepository.getSaldo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error al obtener el saldo'));
                } else {
                  return Center(
                    child: Text(
                      'Saldo Total: \$${snapshot.data?.toStringAsFixed(2) ?? "0.00"}',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  );
                }
              },
            ),
          ),
          Divider(), // Agrega un separador visual para claridad
          Expanded( // Garantiza que la gráfica ocupe el espacio disponible
            child: TransactionChartScreen(),
          ),
        ],
      ),
    );
  }
}