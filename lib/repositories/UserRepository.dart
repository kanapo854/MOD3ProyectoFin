import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/users.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<int> getLastUserId() async {
    QuerySnapshot snapshot = await _db.collection('users').orderBy('id', descending: true).limit(1).get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.get('id');
    } else {
      return 1; // Si no hay usuarios, iniciar desde 1
    }
  }
  Future<void> addUser(Usuario user) async {
    try {
      await _db.collection('users').add(user.toMap());
    } catch (e) {
      throw Exception('Error al guardar el usuario: $e');
    }
  }

  Future<List<Usuario>> getAllUsers() async {
    QuerySnapshot query = await _db.collection('users').get();

    return query.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Usuario.fromMap(doc.id, data);
    }).toList();
  }



  Future<Usuario?> getUserById(int id) async {
    QuerySnapshot query = await _db.collection('users')
      .where('id', isEqualTo: id)
      .limit(1)
      .get();

    if (query.docs.isNotEmpty) 
    {
      return Usuario.fromMap( id.toString(), query.docs.first.data() as Map<String, dynamic>);
    } else {
      return null; // Si no se encuentra el usuario
    }
  }


}