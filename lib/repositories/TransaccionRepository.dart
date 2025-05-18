import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaccion.dart';

class TransaccionRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addTransaccion(Transaccion transaccion) async {
    await _db.collection('transacciones').doc(transaccion.id.toString()).set(transaccion.toMap());
  }

  Future<List<Transaccion>> getAllTransacciones() async {
    QuerySnapshot query = await _db.collection('transacciones').get();
    return query.docs.map((doc) => Transaccion.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<int> getLastTransaccionId() async {
    QuerySnapshot snapshot = await _db.collection('transacciones').orderBy('id', descending: true).limit(1).get();
    return snapshot.docs.isNotEmpty ? snapshot.docs.first.get('id') as int : 1;
  }
}