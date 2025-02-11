import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// Import UserRepository to handle encrypted shared preferences storage
import 'UserRepository.dart';

// ProfilePage is a StatefulWidget that displays user information and allows editing
class ProfilePage extends StatefulWidget {
  final String loginName; // Stores the login name passed from the LoginPage
  final UserRepository userRepository; // Handles encrypted data storage

  // Constructor with required parameters
  const ProfilePage({super.key, required this.loginName, required this.userRepository});

  @override
  State<ProfilePage> createState() => _ProfilePageState(); // Creates mutable state for the ProfilePage
}

// State class containing the logic and UI state for the ProfilePage
class _ProfilePageState extends State<ProfilePage> {
  // Controllers to manage text input fields for user data
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Called when the widget is first inserted into the widget tree
  @override
  void initState() {
    super.initState();
    _loadData(); // Load user data from EncryptedSharedPreferences
  }

  // Called when the widget is removed from the widget tree
  @override
  void dispose() {
    _saveData(); // Save user data before disposing the page
    super.dispose();
  }

  // Load user data from the repository and update the text fields
  Future<void> _loadData() async {
    await widget.userRepository.loadData(); // Load saved data from EncryptedSharedPreferences
    setState(() {
      _firstNameController.text = widget.userRepository.firstName;
      _lastNameController.text = widget.userRepository.lastName;
      _phoneNumberController.text = widget.userRepository.phoneNumber;
      _emailController.text = widget.userRepository.email;
    });
  }

  // Save user data to the repository before the app is closed or navigated away
  Future<void> _saveData() async {
    widget.userRepository.firstName = _firstNameController.text;
    widget.userRepository.lastName = _lastNameController.text;
    widget.userRepository.phoneNumber = _phoneNumberController.text;
    widget.userRepository.email = _emailController.text;
    await widget.userRepository.saveData(); // Store data securely
  }

  // Launch a URL (phone, SMS, or email) and save data before launching
  Future<void> _launchUrlAndSave(String url) async {
    await _saveData(); // Save user data before launching an external action
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // Show an alert dialog if the device does not support the requested action
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('This URL is not supported on your device.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close the alert dialog
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'), // Sets the title of the page
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Adds padding around the content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Aligns text fields to the start (left)
          children: [
            // Displays welcome message with the login name passed from the LoginPage
            Text(
              'Welcome Back, ${widget.loginName}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // First Name input field
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Last Name input field
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Phone Number input field with call and message buttons
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _phoneNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Button to launch phone dialer
                ElevatedButton(
                  onPressed: () => _launchUrlAndSave('tel:${_phoneNumberController.text}'),
                  child: const Icon(Icons.phone),
                ),
                const SizedBox(width: 8),
                // Button to send SMS
                ElevatedButton(
                  onPressed: () => _launchUrlAndSave('sms:${_phoneNumberController.text}'),
                  child: const Icon(Icons.message),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Email input field with email button
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Button to send an email
                ElevatedButton(
                  onPressed: () => _launchUrlAndSave('mailto:${_emailController.text}'),
                  child: const Icon(Icons.mail),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
