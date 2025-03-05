import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class thirdPage extends StatefulWidget {
  const thirdPage({super.key});

  @override
  State<thirdPage> createState() => _thirdPageState();
}

class _thirdPageState extends State<thirdPage> {
  // Function to launch the website
  Future<void> _launchWebsite() async {
    final Uri url = Uri.parse('https://www.algonquincollege.com/');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Third Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Welcome to page 3"),
            const SizedBox(height: 20), // Add some spacing
            ElevatedButton.icon(
              onPressed: _launchWebsite, // Call the _launchWebsite function
              icon: const Icon(Icons.school), // School icon
              label: const Text("Visit Algonquin College"), // Button label
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}