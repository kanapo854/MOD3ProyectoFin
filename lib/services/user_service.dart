import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../repositories/UserRepository.dart';
import '../models/users.dart';

class UserService {
  final UserRepository _repository = UserRepository();

  Future<void> registerUser(String uid, String email, String name) async {
    if (email.isEmpty || name.isEmpty) {
      throw Exception("El correo y nombre no pueden estar vacíos.");
    }

    Usuario user = Usuario(
      id: 1,
      uid: uid,
      email: email,
      name: name,
      role: "cliente",
      estado: "A",
      createdAt: DateTime.now(),
    );

    //await _repository.saveUser(user);
  }

  Future<Usuario?> getUserDetails(int uid) {
    return _repository.getUserById(uid);
  }

  Future<List<Usuario>> fetchAllUsers() {
  return _repository.getAllUsers();
  }

  Future<int?> getUserId() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return null; // El usuario no está autenticado

    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users')
        .where('uid', isEqualTo: user.uid) // Filtrar por el UID de Firebase
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
       var lastUserData = snapshot.docs.first.data() as Map<String, dynamic>;
      return lastUserData.containsKey('id') ? lastUserData['id'] as int : 1;
    } else {
      return null;
    }
  }


}