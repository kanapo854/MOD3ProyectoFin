import 'package:cloud_firestore/cloud_firestore.dart';

class TotalRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<double> getSaldo() async {
    DocumentSnapshot doc = await _db.collection('total').doc('saldo').get();
    if (!doc.exists || doc.data() == null) return 0.0; // Verifica si el documento existe
  
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return data.containsKey('saldo') ? data['saldo'] as double : 0.0;
  }

  Future<void> actualizarSaldo(double nuevoSaldo) async {
    await _db.collection('total').doc('saldo').set({
      'saldo': nuevoSaldo,
      'ultima_actualizacion': DateTime.now().toIso8601String(),
    });
  }
}