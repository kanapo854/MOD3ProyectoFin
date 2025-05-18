import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<int> getLastUserId() async {
  QuerySnapshot snapshot = await _db.collection('users')
    .orderBy('id', descending: true) // Ordena por el ID manual, no por doc.id
    .limit(1)
    .get();

  if (snapshot.docs.isNotEmpty) {
    var lastUserData = snapshot.docs.first.data() as Map<String, dynamic>;
    return lastUserData.containsKey('id') ? lastUserData['id'] as int : 1; // Extrae el ID manual
  } else {
    return 1; // Si no hay usuarios, iniciar desde 1
  }
}


  Future<User?> registerUser(String email, String password, String name) async {
  try {
    int last = await getLastUserId();
    int newId = last+1;
    UserCredential result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = result.user;

    if (user != null) {
      await _db.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'id': newId,
        'email': user.email,
        'name': name,
        'role': 'cliente', 
        'estado':'A',
        'createdAt': DateTime.now().toIso8601String(),
      });
    }

    return user;
  } catch (e) {
    print('Error al registrar usuario: $e');
    return null;
  }
  }

}
