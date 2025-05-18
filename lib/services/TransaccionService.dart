import 'package:libreria/repositories/totalRepository.dart';

import '../repositories/transaccionrepository.dart';
import '../models/transaccion.dart';

class TransaccionService {
  final TransaccionRepository _repository = TransaccionRepository();
  final TotalRepository _totalRepository = TotalRepository();

  Future<void> registrarTransaccion(String tipo, double monto, String referencia, int idUsuario) async {
    if (monto <= 0) throw Exception("El monto debe ser mayor a 0.");
    if (tipo != "ingreso" && tipo != "egreso") throw Exception("Tipo inválido. Debe ser 'ingreso' o 'egreso'.");

    int lastId = await _repository.getLastTransaccionId();
    int newId = lastId + 1;

    //obtener saldo actual
    double saldoActual = await _totalRepository.getSaldo();
    double nuevoSaldo = tipo == "ingreso" ? saldoActual + monto : saldoActual - monto;

    Transaccion transaccion = Transaccion(id: newId, tipo: tipo, monto: monto, referencia: referencia, fecha: DateTime.now(), idUsuario: idUsuario);
    await _repository.addTransaccion(transaccion);

    //guardar saldo
    await _totalRepository.actualizarSaldo(nuevoSaldo);

  }

  Future<List<Transaccion>> obtenerTransacciones() {
    return _repository.getAllTransacciones();
  }

  Future<double> calcularTotal() async {
    List<Transaccion> transacciones = await obtenerTransacciones();
    double total = transacciones.fold(0, (sum, t) => t.tipo == "ingreso" ? sum + t.monto : sum - t.monto);
    return total;
  }
}