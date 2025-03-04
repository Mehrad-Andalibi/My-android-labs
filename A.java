import 'package:flutter/material.dart';
import 'app_database.dart';
import 'shopping_list_page.dart'; // Import separate UI class

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the database before running the app
  initializeDatabase().then((database) {
    runApp(MyApp(database: database));
  }).catchError((error) {
    print("Error initializing database: $error");
  });
}

class MyApp extends StatelessWidget {
  final AppDatabase database;
  const MyApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'To-Do List',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: ShoppingListPage(database: database),
    );
  }
}
