import 'package:flutter/material.dart'; // Import Flutter UI components
import 'todo.dart'; // Import the Todo model


class DetailsPage extends StatelessWidget {
  final Todo todo;
  final Function(Todo) onDelete;
  final VoidCallback onClose;

  DetailsPage({required this.todo, required this.onDelete, required this.onClose});

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
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    onDelete(todo);
                    Navigator.pop(context);
                  },
                  child: Text('Delete'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onClose,
                  child: Text('Close'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}