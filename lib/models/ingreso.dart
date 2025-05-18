import 'package:cloud_firestore/cloud_firestore.dart';

class Ingreso {
  final int id;
  final double monto;
  final String fuente;
  final DateTime fecha;
  final int idUsuario;
  final String titulo;

  Ingreso({required this.id, required this.monto, required this.fuente, required this.fecha, required this.idUsuario, required this.titulo});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'monto': monto,
      'fuente': fuente,
      'fecha': fecha.toIso8601String(),
      'IdUsuario': idUsuario,
      'titleLib': titulo
    };

  }

  factory Ingreso.fromMap(Map<String, dynamic> map) {
    return Ingreso(
      id: map['id'] as int,
      monto: map['monto'] as double,
      fuente: map['fuente'],
      //fecha: DateTime.parse(map['fecha']),
      fecha: map['fecha'] is Timestamp 
      ? (map['fecha'] as Timestamp).toDate()
      : DateTime.parse(map['fecha']),
      idUsuario: map['idIsuario'],
      titulo: map['titleLib']
    );
  }
}