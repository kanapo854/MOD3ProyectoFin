import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ingreso.dart';

class IngresoRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addIngreso(Ingreso ingreso) async {
    await _db.collection('ingresos').doc(ingreso.id.toString()).set(ingreso.toMap());
  }

  Future<List<Ingreso>> getAllIngresos() async {
    QuerySnapshot query = await _db.collection('ingresos').get();
    return query.docs.map((doc) => Ingreso.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<int> getLastIngresoId() async {
    QuerySnapshot snapshot = await _db.collection('ingresos').orderBy('id', descending: true).limit(1).get();
    return snapshot.docs.isNotEmpty ? snapshot.docs.first.get('id') as int : 1;
  }
}