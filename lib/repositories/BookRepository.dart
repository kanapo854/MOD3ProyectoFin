import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book.dart';

class BookRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<int> getLastBookId() async {
    QuerySnapshot snapshot = await _db.collection('books').orderBy('id', descending: true).limit(1).get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.get('id');
    } else {
      return 0; // Si no hay libros, iniciar desde 0
    }
  }
  Future<void> addBook(Book book) async {
    try {
      bool existe = await bookExists(book.title);
      if(!existe){
        await _db.collection('books').doc(book.id.toString()).set(book.toMap());
      }
      else {
        throw Exception('El libro ya se encuentra registrado.');
      }
    } catch (e) {
      throw Exception('Error al guardar el libro: $e');
    }
  }

  Stream<List<Book>> getBooks() {
    return _db.collection('books').snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Book.fromMap(doc.data())).toList());
  }

  Future<void> updateBook(String id, Book libro) async {
    DocumentSnapshot doc = await _db.collection('books').doc(id).get();
    if (!doc.exists) throw Exception("No se encontró un libro con el ID: $id");
    await _db.collection('books').doc(id).update(libro.toMap());
  }


  Future<bool> bookExists(String titulo) async {
    QuerySnapshot snapshot = await _db.collection('books')
      .where('title', isEqualTo: titulo) // Buscar libro con el mismo título
      .limit(1)
      .get();

    return snapshot.docs.isNotEmpty; // Retorna `true` si ya existe
  }
}