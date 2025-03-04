import 'package:flutter/material.dart';
import 'todo.dart';

class DetailsPage extends StatelessWidget {
  final Todo todo;
  final Function(Todo) onDelete;

  DetailsPage({required this.todo, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${todo.id}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 8),
            Text('Title: ${todo.title}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                onDelete(todo);
                if (Navigator.canPop(context)) {
                  Navigator.pop(context); // Pop only if it's not the root
                }
              },
              child: Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}