import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/egreso.dart';

class EgresoRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addEgreso(Egreso egreso) async {
    await _db.collection('egresos').doc(egreso.id.toString()).set(egreso.toMap());
  }

  Future<List<Egreso>> getAllEgresos() async {
    QuerySnapshot query = await _db.collection('egresos').get();
    return query.docs.map((doc) => Egreso.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<int> getLastEgresoId() async {
    QuerySnapshot snapshot = await _db.collection('egresos').orderBy('id', descending: true).limit(1).get();
    return snapshot.docs.isNotEmpty ? snapshot.docs.first.get('id') as int : 1;
  }
}