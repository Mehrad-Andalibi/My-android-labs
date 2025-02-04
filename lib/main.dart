// Importing the necessary packages from Flutter for UI components
import 'package:flutter/material.dart';
// Importing the package for securely storing data using encrypted shared preferences
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

// Entry point of the Flutter application
void main() {
  runApp(const MyApp()); // Runs the MyApp widget as the root of the application
}

// Stateless widget representing the root of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructor with optional key parameter

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo', // Title of the application
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), // Sets a primary color scheme
        useMaterial3: true, // Uses Material 3 design principles
      ),
      home: const LoginPage(), // Specifies the home page of the app
    );
  }
}

// Stateful widget representing the login page
class LoginPage extends StatefulWidget {
  const LoginPage({super.key}); // Constructor with optional key parameter

  @override
  State<LoginPage> createState() => _LoginPageState(); // Creates the mutable state for the login page
}

// State class containing the logic and UI state for the LoginPage
class _LoginPageState extends State<LoginPage> {
  // Controllers to manage the text input for login and password fields
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // Instance of EncryptedSharedPreferences to securely store user credentials
  final EncryptedSharedPreferences _encryptedPrefs = EncryptedSharedPreferences();

  // Variable to manage the displayed image based on login validation
  var imageSource = "images/question-mark.png";

  // Called when the widget is inserted into the widget tree
  @override
  void initState() {
    super.initState();
    _loadCredentials(); // Loads saved credentials when the app starts
  }

  // Loads credentials from encrypted shared preferences
  Future<void> _loadCredentials() async {
    try {
      String? savedLogin = await _encryptedPrefs.getString('login'); // Retrieve saved login
      String? savedPassword = await _encryptedPrefs.getString('password'); // Retrieve saved password

      // If credentials exist, populate the text fields and show a snackbar
      if (savedLogin != null && savedPassword != null) {
        setState(() {
          _loginController.text = savedLogin; // Populate login field
          _passwordController.text = savedPassword; // Populate password field
        });

        // Show a snackbar indicating that previous login details were loaded
        Future.delayed(const Duration(seconds: 3), (){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Previous login details loaded.'),
            action: SnackBarAction(
              label: 'Undo', // Label for undo action
              onPressed: () {
                setState(() {
                  _loginController.clear(); // Clear login field
                  _passwordController.clear(); // Clear password field
                });
              },
            ),
          ),
        );
      });
    } catch (e) {
      // Handle any errors that occur while retrieving encrypted data
      print('Error loading credentials: \$e');
    }
  }

  // Validates the login credentials entered by the user
  void _validateLogin() {
    setState(() {
      // Check if the password matches the predefined value
      if (_passwordController.text == "QWERTY123") {
        imageSource = "images/light-bulb.png"; // Display light-bulb image for correct password
      } else {
        imageSource = "images/stop-sign.png"; // Display stop-sign image for incorrect password
      }
    });

    _showSaveDialog(); // Prompt user to save credentials after validation
  }

  // Displays an AlertDialog asking the user if they want to save their credentials
  void _showSaveDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Login?'), // Dialog title
          content: const Text('Would you like to save your username and password for next time?'), // Dialog message
          actions: [
            TextButton(
              onPressed: () {
                _clearCredentials(); // Clear saved credentials if user selects 'No'
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No'), // Button to decline saving credentials
            ),
            TextButton(
              onPressed: () {
                _saveCredentials(); // Save credentials if user selects 'Yes'
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Yes'), // Button to confirm saving credentials
            ),
          ],
        );
      },
    );
  }

  // Saves the login and password to encrypted shared preferences
  Future<void> _saveCredentials() async {
    try {
      await _encryptedPrefs.setString('login', _loginController.text); // Save login
      await _encryptedPrefs.setString('password', _passwordController.text); // Save password
    } catch (e) {
      // Handle any errors that occur while saving credentials
      print('Error saving credentials: \$e');
    }
  }

  // Clears the saved login and password from encrypted shared preferences
  Future<void> _clearCredentials() async {
    try {
      await _encryptedPrefs.remove('login'); // Remove saved login
      await _encryptedPrefs.remove('password'); // Remove saved password
    } catch (e) {
      // Handle any errors that occur while clearing credentials
      print('Error clearing credentials: \$e');
    }
  }

  // Builds the UI of the login page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Demo Home Page"), // Title displayed in the app bar
        backgroundColor: Theme.of(context).colorScheme.inversePrimary, // Set app bar background color
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Padding around the form elements
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center the elements vertically
              children: [
                // TextField for entering login
                TextField(
                  controller: _loginController, // Connects the text field to the login controller
                  decoration: const InputDecoration(
                    labelText: "Login", // Label for the login field
                    border: OutlineInputBorder(), // Adds a border around the text field
                  ),
                ),
                const SizedBox(height: 16.0), // Adds vertical spacing
                // TextField for entering password
                TextField(
                  controller: _passwordController, // Connects the text field to the password controller
                  obscureText: true, // Hides the password input
                  decoration: const InputDecoration(
                    labelText: "Password", // Label for the password field
                    border: OutlineInputBorder(), // Adds a border around the text field
                  ),
                ),
                const SizedBox(height: 16.0), // Adds vertical spacing
                // Button to trigger login validation
                ElevatedButton(
                  onPressed: _validateLogin, // Calls the _validateLogin method when pressed
                  child: const Text("Login"), // Text displayed on the button
                ),
                const SizedBox(height: 16.0), // Adds vertical spacing
                // Displays an image based on login validation result
                Image.asset(
                  imageSource, // Image source path
                  width: 300, // Width of the image
                  height: 300, // Height of the image
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
