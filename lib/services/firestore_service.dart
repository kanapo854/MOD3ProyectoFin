/*import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Future<void> addBook(Book book) {
    return _db.collection('books').add(book.toMap());
  }

  Stream<List<Book>> getBooks() {
    return _db.collection('books').snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Book.fromMap(doc.id, doc.data())).toList());
  }
}*/
