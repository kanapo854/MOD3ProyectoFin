import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libreria/models/book.dart';
import 'package:libreria/services/BookService.dart';
import 'package:libreria/services/user_service.dart';

class EditBookScreen extends StatefulWidget {
  final Book libro;

  EditBookScreen({required this.libro});

  @override
  _EditBookScreenState createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  final BookService _bookService = BookService();
  final UserService _userService = UserService();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController categoriaController = TextEditingController();
  late int stockinicial;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.libro.title;
    authorController.text = widget.libro.author;
    priceController.text = widget.libro.price.toString();
    stockController.text = widget.libro.stock.toString();
    stockController.text = widget.libro.stock.toString();
    categoriaController.text = widget.libro.categoria;
    stockinicial = widget.libro.stock;
  }

  void _updateBook() async {
    try {
      int? userId = await await _userService.getUserId();
      if(userId == null){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se puede obtener el ID del usuario'))
        );
        return;
      }
      int nuevostock = int.parse(stockController.text);
      int stockagregado = nuevostock - stockinicial;
      Book libroActualizado = Book(
        id: widget.libro.id,
        title: titleController.text,
        author: authorController.text,
        price: double.parse(priceController.text),
        stock: int.parse(stockController.text),
        estado: "M",
        categoria: categoriaController.text,
        createdAt: widget.libro.createdAt,
      );

      await _bookService.actualizarLibro(widget.libro.id.toString(), libroActualizado, stockagregado, userId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Libro actualizado')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 195, 243, 223), 
      appBar: AppBar(title: Text('Editar Libro')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleController, 
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
              decoration: InputDecoration(
                labelText: 'Título',
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 11, 59, 47),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 11, 59, 47))
                )
              ), 
              enabled: false,
            ),
            TextField(
              controller: authorController, 
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
              decoration: InputDecoration(
                labelText: 'Autor',
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 11, 59, 47),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 11, 59, 47))
                )
              ), 
              enabled: false,
            ),
            TextField(
              controller: priceController, 
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
              decoration: InputDecoration(
                labelText: 'Precio',
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 11, 59, 47),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 11, 59, 47))
                )
              ), 
              keyboardType: TextInputType.number, 
              enabled: false,
            ),
            TextField(
              controller: stockController, 
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: 'Stock',
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 11, 59, 47),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 11, 59, 47))
                )
              ), 
              keyboardType: TextInputType.number
            ),
            TextField(
              controller: categoriaController, 
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
              decoration: InputDecoration(
                labelText: 'Categoria',
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 11, 59, 47),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 11, 59, 47))
                )
              ), 
              enabled: false,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateBook, 
              child: Text('Actualizar Libro'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 11, 59, 47),
                foregroundColor: Colors.white
              ),
            ),
          ],
        ),
      ),
    );
  }
}