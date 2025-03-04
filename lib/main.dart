import 'package:flutter/material.dart';
import 'package:floor/floor.dart';
import 'database.dart';
import 'todo.dart';
import 'details_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await $FloorAppDatabase
      .databaseBuilder('app_database.db')
      .build();

  runApp(MyApp(database));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;

  MyApp(this.database);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(database),
    );
  }
}

class HomePage extends StatefulWidget {
  final AppDatabase database;

  HomePage(this.database);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  List<Todo> _items = [];
  Todo? _selectedItem;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final items = await widget.database.todoDao.findAllTodos();
    setState(() {
      _items = items;
    });
  }

  void _addItem() async {
    if (_controller.text.isNotEmpty) {
      final newTodo = Todo(
        _items.isEmpty ? 1 : _items.last.id + 1,
        _controller.text,
      );
      await widget.database.todoDao.insertTodo(newTodo);
      setState(() {
        _items.add(newTodo);
        _controller.clear();
      });
    }
  }

  void _deleteItem(Todo item) async {
    await widget.database.todoDao.deleteTodo(item);
    setState(() {
      _items.remove(item);
      if (_selectedItem == item) {
        _selectedItem = null;
      }
    });
  }

  void _onItemTap(Todo item) {
    setState(() {
      _selectedItem = item;
    });
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    bool isLandscape = (size.width>size.height)&&(size.width>720);

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('Flutter Demo Home Page'),
        backgroundColor: Color(0xFFD1C4E9),
      ),
      body: Stack(
        children: [
          Row(
            children: [
              Expanded(
                flex: (isLandscape ? 2 : 1) ,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: _addItem,
                            child: Text('Add'),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                ),
                                hintText: 'Enter a todo item',
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Expanded(
                        child: _items.isEmpty
                            ? Center(child: Text('There are no items in the list'))
                            : ListView.builder(
                          itemCount: _items.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                _onItemTap(_items[index]);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey[300]!),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text('Row number: $index'),
                                    Text(_items[index].title),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isLandscape && _selectedItem != null)
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        left: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    child: DetailsPage(todo: _selectedItem!, onDelete: _deleteItem),
                  ),
                ),
            ],
          ),
          if ( !isLandscape)
            if (_selectedItem != null)
              Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                left: 0,
                child: Container(
                  color: Colors.white,
                  child: DetailsPage(todo: _selectedItem!, onDelete: _deleteItem),
                ),
              ),
        ],
      ),
    );
  }
}