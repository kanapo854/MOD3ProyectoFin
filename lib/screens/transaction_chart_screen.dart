import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionChartScreen extends StatelessWidget {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gráfico de Transacciones")),
      body: FutureBuilder<QuerySnapshot>(
        future: _db.collection('transacciones').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al obtener las transacciones'));
          }

          List<QueryDocumentSnapshot> transactions = snapshot.data?.docs ?? [];
          double ingresos = 0;
          double egresos = 0;

          for (var transaction in transactions) {
            double monto = (transaction['monto'] is int) ? transaction['monto'].toDouble() : transaction['monto'];
            if (transaction['tipo'] == 'ingreso') {
              ingresos += monto;
            } else {
              egresos += monto;
            }
          }

          return Center(
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              //title: ChartTitle(text: 'Ingresos vs Egresos'),
              legend: Legend(isVisible: true),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CartesianSeries<TransactionData, String>>[
              ColumnSeries<TransactionData, String>(
                dataSource: [
                  TransactionData('Ingresos', ingresos),
                  TransactionData('Egresos', egresos),
                ],
                xValueMapper: (TransactionData trans, _) => trans.tipo,
                yValueMapper: (TransactionData trans, _) => trans.monto,
                name: 'Transacciones',
                color: const Color.fromARGB(255, 14, 46, 35),
              ),
            ],

            ),
          );
        },
      ),
    );
  }
}

class TransactionData {
  final String tipo;
  final double monto;

  TransactionData(this.tipo, this.monto);
}