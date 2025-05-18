import 'package:libreria/services/TransaccionService.dart';

import '../repositories/IngresosRepository.dart';
import '../models/ingreso.dart';

class IngresoService {
  final IngresoRepository _repository = IngresoRepository();
  final TransaccionService _transaccionService = TransaccionService();
  Future<void> registrarIngreso(String fuente, double monto, int idUsuario, String title) async {
    if (monto <= 0) throw Exception("El monto debe ser mayor a 0.");

    int lastId = await _repository.getLastIngresoId();
    int newId = lastId + 1;

    Ingreso ingreso = Ingreso(id: newId, monto: monto, fuente: fuente, fecha: DateTime.now(), idUsuario: idUsuario, titulo: title);
    await _repository.addIngreso(ingreso);
    await _transaccionService.registrarTransaccion("ingreso", monto, fuente, idUsuario);
  }

  Future<List<Ingreso>> obtenerIngresos() {
    return _repository.getAllIngresos();
  }
}