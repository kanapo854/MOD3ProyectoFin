import 'package:flutter/material.dart';
import 'package:libreria/repositories/UserRepository.dart';
import 'package:libreria/screens/admin_home_screen.dart';
import 'package:libreria/screens/lista_libro_screen.dart';
import 'package:libreria/services/BookService.dart';
import 'package:libreria/services/user_service.dart';

class RegisterBookScreen extends StatefulWidget {
  @override
  _RegisterBookScreenState createState() => _RegisterBookScreenState();
}

class _RegisterBookScreenState extends State<RegisterBookScreen> {
  final BookService _bookService = BookService();
  final UserService _userService = UserService();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController categoriaController = TextEditingController();
  
  void _registerBook() async {
    int? userId = await await _userService.getUserId();
    if(userId == null){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se puede obtener el ID del usuario'))
      );
      return;
    }

    if (titleController.text.isNotEmpty && authorController.text.isNotEmpty &&
        priceController.text.isNotEmpty && stockController.text.isNotEmpty && categoriaController.text.isNotEmpty) {
      try {
        await _bookService.registerBook(
          titleController.text,
          authorController.text,
          double.parse(priceController.text),
          int.parse(stockController.text),
          "A",
          categoriaController.text,
          userId
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Libro registrado correctamente')),
          
        );
        
        titleController.clear();
        authorController.clear();
        priceController.clear();
        stockController.clear();
        categoriaController.clear();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BookListScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Todos los campos son obligatorios')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 195, 243, 223), 
      appBar: AppBar(title: Text('Registrar Libro')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleController, 
              decoration: InputDecoration(
                labelText: 'Título', 
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 11, 59, 47),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 11, 59, 47))
                )
              )
            ),
            TextField(
              controller: authorController, 
              decoration: InputDecoration(
                labelText: 'Autor',
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 11, 59, 47),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 11, 59, 47))
                )
              )
            ),
            TextField(
              controller: priceController, 
              decoration: InputDecoration(
                labelText: 'Precio',
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 11, 59, 47),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 11, 59, 47))
                )
                ), 
                keyboardType: TextInputType.number),
            TextField(
              controller: stockController, 
              decoration: InputDecoration(
                labelText: 'Stock',
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 11, 59, 47),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 11, 59, 47))
                )
                ), 
                keyboardType: TextInputType.number),
            TextField(
              controller: categoriaController, 
              decoration: InputDecoration(
                labelText: 'Categoria',
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 11, 59, 47),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 11, 59, 47))
                )
                ),
                ),
            SizedBox(height: 9),
            ElevatedButton(onPressed: _registerBook, child: Text('Registrar Libro'),
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