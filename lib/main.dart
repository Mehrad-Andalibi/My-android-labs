import 'package:flutter/material.dart';
import 'package:in_class/secondPage.dart';
import 'package:in_class/thirdPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_class/data.dart'; // Import the DataRepository
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Layout Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LakeOeschinenPage(),
      routes: {
        '/second': (context) => const secondPage(),
        '/third': (context) => const thirdPage(),
      },
    );
  }
}

class LakeOeschinenPage extends StatefulWidget {
  const LakeOeschinenPage({super.key});

  @override
  State<LakeOeschinenPage> createState() => _LakeOeschinenPageState();
}

class _LakeOeschinenPageState extends State<LakeOeschinenPage> {
  int _button1Count = 0;
  int _button2Count = 0;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCounts(); // Load counts when the app starts
  }

  // Load counts from shared preferences
  Future<void> _loadCounts() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _button1Count = prefs.getInt('button1Count') ?? 0;
      _button2Count = prefs.getInt('button2Count') ?? 0;
    });
  }

  // Save counts to shared preferences
  Future<void> _saveCount(String buttonKey, int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(buttonKey, count);
  }

  // Increment count for Button 1
  void _incrementButton1Count() {
    setState(() {
      _button1Count++;
    });
    _saveCount('button1Count', _button1Count); // Save the updated count
  }

  // Increment count for Button 2
  void _incrementButton2Count() {
    setState(() {
      _button2Count++;
    });
    _saveCount('button2Count', _button2Count); // Save the updated count
  }

  // Handle save action
  void _handleSave() {
    final text = _textController.text;
    DataRepository.setLoginName(text); // Save the text to DataRepository
    print('Saved text: $text');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Flutter Layout Demo',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'images/img_1.png', // Replace with your image path
              width: double.infinity,
              height: 240,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Oeschinen Lake Campground',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: 20,
                      ),
                      const Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: 20,
                      ),
                      const Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: 20,
                      ),
                      const Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: 20,
                      ),
                      const Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '41',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Kandersteg, Switzerland',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildButtonColumn(
                        context,
                        Colors.blue,
                        Icons.call,
                        'CALL',
                        'Call button clicked!',
                      ),
                      _buildButtonColumn(
                        context,
                        Colors.blue,
                        Icons.near_me,
                        'ROUTE',
                        'Route button clicked!',
                      ),
                      _buildButtonColumn(
                        context,
                        Colors.blue,
                        Icons.share,
                        'SHARE',
                        'Share button clicked!',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese Alps. Situated 1,578 meters above sea level, it is one of the larger Alpine Lakes. A gondola ride from Kandersteg, followed by a half-hour walk through pastures and pine forest, leads you to the lake, which warms to 20 degrees Celsius in the summer. Activities enjoyed here include rowing, and riding the summer toboggan run.',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Display button click counts and text field
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Button 1 Clicks: $_button1Count',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Button 2 Clicks: $_button2Count',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            TextField(
                              controller: _textController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Enter text',
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: _handleSave,
                              child: const Text('Save'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/second');
                _incrementButton1Count(); // Increment Button 1 count
                _showAlertDialog(context, 'Button 1', 'You clicked Button 1!');
              },
              child: const Text('Button 1'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/third');
                _incrementButton2Count(); // Increment Button 2 count
                _showAlertDialog(context, 'Button 2', 'You clicked Button 2!');
              },
              child: const Text('Button 2'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonColumn(
      BuildContext context,
      Color color,
      IconData icon,
      String label,
      String snackBarMessage,
      ) {
    return GestureDetector(
      onTap: () {
        // Show SnackBar when the button is clicked
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackBarMessage),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}