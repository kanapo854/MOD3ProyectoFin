import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libreria/screens/historial_compras.dart';
import 'package:libreria/services/IngresoService.dart';
import 'package:libreria/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:libreria/screens/user_purchases_screen.dart';
import 'package:libreria/screens/login_screen.dart';

class BookStoreScreen extends StatelessWidget {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final IngresoService _ingresoService = IngresoService();
  final UserService _userService = UserService();

  Future<void> _registrarCompra(double precio, context, String title) async {
    int? userId = await _userService.getUserId();
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se puede obtener el ID del usuario')),
      );
      return;
    }
    if (precio > 0) {
      await _ingresoService.registrarIngreso('Venta de libro', precio, userId, title);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Compra realizada con éxito')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 195, 243, 223), 
      appBar: AppBar(
        title: Text('Libros Disponibles'),
        actions: [
          PopupMenuButton<String>(
            offset: Offset(0, 50),
            onSelected: (value) {
              if (value == 'Ver Compras') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserPurchasesScreen()));
              } else if (value == 'Cerrar Sesión') {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(value: 'Ver Compras', child: Text('Ver Mis Compras')),
              PopupMenuItem(value: 'Cerrar Sesión', child: Text('Cerrar Sesión')),
            ],
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _db.collection('books').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al obtener los libros'));
          }

          List<QueryDocumentSnapshot> books = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              var book = books[index];
              return ListTile(
                title: Text(book['title']),
                subtitle: Text('\$${book['price'].toStringAsFixed(2)}'),
                trailing: ElevatedButton(
                  onPressed: () => _registrarCompra(book['price'], context, book['title']),
                  child: Text('Comprar'),
                  style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 11, 59, 47),
                foregroundColor: Colors.white
              ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}