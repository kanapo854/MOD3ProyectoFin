import 'package:flutter/material.dart';
import 'package:libreria/models/book.dart';
import 'package:libreria/screens/edit_book_screen.dart';
import 'package:libreria/screens/register_book_screen.dart';
import 'package:libreria/services/BookService.dart';

class BookListScreen extends StatelessWidget {
  final BookService _bookService = new BookService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 195, 243, 223), 
      appBar: AppBar(title: Text('Lista de Libros')),
      body: StreamBuilder<List<Book>>(
        stream: _bookService.fetchBooks(), // Escuchar cambios en Firestore
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al obtener los libros'));
          }

          final libros = snapshot.data ?? [];

          return ListView.builder(
            itemCount: libros.length,
            itemBuilder: (context, index) {
              var libro = libros[index];
              return ListTile(
                title: Text(libro.title),
                subtitle: Text('Autor: ${libro.author}'),
                trailing: Text('\$${libro.price.toStringAsFixed(2)}'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => EditBookScreen(libro: libro),
                  ));
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:Color.fromARGB(255, 11, 59, 47),
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => RegisterBookScreen(), // Ir a la pantalla de agregar libros
          ));
        },
        child: Icon(Icons.add),
        tooltip: "Agregar libro",
      ),

    );
  }
}