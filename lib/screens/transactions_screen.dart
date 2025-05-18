import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TransactionListScreen extends StatelessWidget {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 195, 243, 223), 
      appBar: AppBar(title: Text('Historial de Transacciones')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _db.collection('transacciones').orderBy('fecha', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al obtener las transacciones'));
          }

          final transactions = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              var transaction = transactions[index];
              bool esIngreso = transaction['tipo'] == 'ingreso';

              return ListTile(
                title: Text('\$${transaction['monto'].toStringAsFixed(2)}',
                  style: TextStyle(color: esIngreso ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
                subtitle: Text('${DateFormat('yyyy-MM-dd').format(DateTime.parse(transaction['fecha']))}\n${transaction['referencia']}'),
                trailing: Text(transaction['tipo'].toUpperCase(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              );
            },
          );
        },
      ),
    );
  }
}