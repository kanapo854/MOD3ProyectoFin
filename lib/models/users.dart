import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  final int id;
  final String email;
  final String name;
  final String role;
  final String estado;
  final String uid;
  final DateTime createdAt;

  Usuario({required this.id, required this.email, required this.name, required this.role, required this.estado, required this.uid, required this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'estado': estado,
      'createdAt': createdAt.toIso8601String(),
      'uid': uid
    };
  }

  factory Usuario.fromMap(String id, Map<String, dynamic> map) {
    return Usuario(
      id: map.containsKey('id')? map['id'] as int:0,
      email: map['email'],
      name: map['name'],
      role: map['role'],
      estado: map['estado'],
      uid: map['uid'],
      //createdAt: DateTime.parse(map['createdAt']),
      createdAt: map['createdAt'] is Timestamp 
      ? (map['createdAt'] as Timestamp).toDate()
      : DateTime.parse(map['createdAt']),

    );
  }
}
