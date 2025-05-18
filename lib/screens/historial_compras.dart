import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:libreria/services/user_service.dart';

class UserPurchasesScreen extends StatefulWidget {
  @override
  _UserPurchasesScreenState createState() => _UserPurchasesScreenState();
}

class _UserPurchasesScreenState extends State<UserPurchasesScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final UserService _userService = UserService();
  int userId = 0; // Valor por defecto para evitar errores de consulta

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    int id = await _userService.getUserId() ?? 0;
    if (mounted) {
      setState(() {
        userId = id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 195, 243, 223), 
      appBar: AppBar(title: Text('Historial de Compras')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _db.collection('ingresos')
            .where('IdUsuario', isEqualTo: userId)
            .orderBy('fecha', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al obtener las compras'));
          }

          List<QueryDocumentSnapshot> purchases = snapshot.data?.docs ?? [];

          return purchases.isEmpty
              ? Center(child: Text('No tienes compras registradas.'))
              : ListView.builder(
                  itemCount: purchases.length,
                  itemBuilder: (context, index) {
                    var purchase = purchases[index];
                    return ListTile(
                      title: Text(purchase['titleLib']),
                      subtitle: Text('\$${purchase['monto'].toStringAsFixed(2)}'),
                      trailing: Text(
                        '${DateFormat('yyyy-MM-dd').format(DateTime.parse((purchase['fecha']))) }',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}