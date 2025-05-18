import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Transaccion {
  final int id;
  final String tipo; // "ingreso" o "egreso"
  final double monto;
  final String referencia;
  final DateTime fecha;
  final int idUsuario;

  Transaccion({required this.id, required this.tipo, required this.monto, required this.referencia, required this.fecha, required this.idUsuario});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tipo': tipo,
      'monto': monto,
      'referencia': referencia,
      'fecha': fecha.toIso8601String(),
      'idUsuario': idUsuario
    };
  }

  factory Transaccion.fromMap(Map<String, dynamic> map) {
    return Transaccion(
      id: map['id'] as int,
      tipo: map['tipo'],
      monto: map['monto'] as double,
      referencia: map['referencia'],
      //fecha: DateTime.parse(map['fecha']),
      fecha: map['fecha'] is Timestamp 
      ? (map['fecha'] as Timestamp).toDate()
      : DateTime.parse(map['fecha']),
      idUsuario: map['idUsuario']
    );
  }
}