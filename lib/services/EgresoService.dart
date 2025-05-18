import 'dart:ffi';

import 'package:libreria/models/book.dart';
import 'package:libreria/repositories/totalRepository.dart';
import 'package:libreria/services/TransaccionService.dart';

import '../repositories/egresoRepository.dart';
import '../models/egreso.dart';

class EgresoService {
  final EgresoRepository _repository = EgresoRepository();
  final TransaccionService _transaccionService = TransaccionService();
  final TotalRepository _totalRepository = TotalRepository();

  Future<void> registrarEgreso(String categoria, double monto, int idUsuario) async {
    if (monto <= 0) throw Exception("El monto debe ser mayor a 0.");
    double saldoActual = await _totalRepository.getSaldo();
    if (saldoActual < monto) throw Exception("Saldo insuficiente para realizar este egreso.");

    int lastId = await _repository.getLastEgresoId();
    int newId = lastId + 1;

    Egreso egreso = Egreso(id: newId, monto: monto, categoria: categoria, fecha: DateTime.now(), idUsuario: idUsuario);
    await _repository.addEgreso(egreso);

    //Registrar transacción automatica
    await _transaccionService.registrarTransaccion("egreso", monto, categoria, idUsuario);
  }

  Future<List<Egreso>> obtenerEgresos() {
    return _repository.getAllEgresos();
  }
  Future<void> registrarEgresoPorLibro(Book libro, int idUsuario) async {
    if (libro.stock <= 0) throw Exception("El stock debe ser mayor a 0.");
    if (libro.price <= 0) throw Exception("El precio debe ser mayor a 0.");

    double montoTotal = libro.price * libro.stock;
    
    int lastId = await _repository.getLastEgresoId();
    int newId = lastId + 1;

    Egreso egreso = Egreso(id: newId, monto: montoTotal, categoria: "Compra de libros", fecha: DateTime.now(), idUsuario: idUsuario);
    await _repository.addEgreso(egreso);
    await _transaccionService.registrarTransaccion("egreso", montoTotal, "Compra de libros", idUsuario);
  }
  Future<void> registrarEgresoPorIncrementoInventario(Book libro, int idUsuario, int stockagregado) async {
    if (libro.stock <= 0) throw Exception("El stock debe ser mayor a 0.");
    if (libro.price <= 0) throw Exception("El precio debe ser mayor a 0.");

    double montoTotal = libro.price * stockagregado;
    
    int lastId = await _repository.getLastEgresoId();
    int newId = lastId + 1;

    Egreso egreso = Egreso(id: newId, monto: montoTotal, categoria: "Actualización de inventario", fecha: DateTime.now(), idUsuario: idUsuario);
    await _repository.addEgreso(egreso);
    await _transaccionService.registrarTransaccion("egreso", montoTotal, "Actualización de inventario", idUsuario);
  }

}