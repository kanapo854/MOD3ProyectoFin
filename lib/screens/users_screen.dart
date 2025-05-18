import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/users.dart';

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();

}

class _UsersScreenState extends State<UsersScreen> {
  final UserService _userService = UserService();
  late Future<List<Usuario>> _usersFuture;

  @override
  void initState() {
    super.initState();
    //_debugUsers();
    _usersFuture = _userService.fetchAllUsers();
  }
  void _debugUsers() async {
  List<Usuario> users = await _userService.fetchAllUsers();
  print(users); // Muestra los usuarios en la consola
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 195, 243, 223), 
      appBar: AppBar(title: Text('Usuarios Registrados')),
      body: FutureBuilder<List<Usuario>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var users = snapshot.data!;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              return Card(
                color: const Color.fromARGB(255, 161, 172, 165),
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(user.name ?? 'Sin nombre'),
                  subtitle: Text(user.email ?? 'Sin email'),
                  trailing: Text(user.role ?? 'Sin rol'),
                ),
                
              );
            },
          );
        },
      ),
    );
  }
}