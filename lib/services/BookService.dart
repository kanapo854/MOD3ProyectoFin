import 'package:libreria/repositories/totalRepository.dart';
import 'package:libreria/services/EgresoService.dart';

import '../repositories/BookRepository.dart';
import '../models/book.dart';

class BookService {
  final BookRepository _repository = BookRepository();
  final EgresoService _egresoService = EgresoService();
  //BookService(this._repository);
  final TotalRepository _totalRepository = TotalRepository();
  
  Future<void> registerBook(String title, String author, double price, int stock, String estado, String categoria, int idUsuario) async {
    if (title.isEmpty || author.isEmpty || price <= 0 || stock <= 0 || estado.isEmpty || categoria.isEmpty) {
      throw Exception("Los datos del libro son inválidos");
    }

    int lastId = await _repository.getLastBookId();
    int newId = lastId + 1;
    Book book = Book(id: newId, title: title, author: author, price: price, stock: stock, estado: estado, createdAt:  DateTime.now(), categoria: categoria);
    
    double saldoActual = await _totalRepository.getSaldo();
    double monto = price * stock;
    if (saldoActual < monto) throw Exception("Saldo insuficiente para realizar este egreso.");

    await _repository.addBook(book);
    await _egresoService.registrarEgresoPorLibro(book, idUsuario);
  }

  Stream<List<Book>> fetchBooks() {
    return _repository.getBooks();
  }
  Future<void> actualizarLibro(String id, Book libro, int stockagregado, int idUsuario) async {
    if (libro.price <= 0) throw Exception("El precio debe ser mayor a 0.");
    if (libro.stock < 0) throw Exception("El stock no puede ser negativo.");
    
    double saldoActual = await _totalRepository.getSaldo();
    double monto = libro.price * stockagregado;
    if (saldoActual < monto) throw Exception("Saldo insuficiente para realizar este egreso.");
    await _repository.updateBook(id, libro);
    await _egresoService.registrarEgresoPorIncrementoInventario(libro, idUsuario, stockagregado);
  }

}