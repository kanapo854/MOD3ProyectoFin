import 'package:cloud_firestore/cloud_firestore.dart';

class Egreso {
  final int id;
  final double monto;
  final String categoria;
  final DateTime fecha;
  final int idUsuario;

  Egreso({required this.id, required this.monto, required this.categoria, required this.fecha, required this.idUsuario});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'monto': monto,
      'categoria': categoria,
      'fecha': fecha.toIso8601String(),
      'idUsuario': idUsuario
    };
  }

  factory Egreso.fromMap(Map<String, dynamic> map) {
    return Egreso(
      id: map['id'] as int,
      monto: map['monto'] as double,
      categoria: map['categoria'],
      //fecha: DateTime.parse(map['fecha']),
      fecha: map['fecha'] is Timestamp 
      ? (map['fecha'] as Timestamp).toDate()
      : DateTime.parse(map['fecha']),
      idUsuario: map['idUsuario']
    );
  }
}