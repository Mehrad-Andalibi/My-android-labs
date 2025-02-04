import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final EncryptedSharedPreferences _encryptedPrefs = EncryptedSharedPreferences();

  var imageSource = "images/question-mark.png";

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    try {
      String? savedLogin = await _encryptedPrefs.getString('login');
      String? savedPassword = await _encryptedPrefs.getString('password');

      if (savedLogin != null && savedPassword != null) {
        setState(() {
          _loginController.text = savedLogin;
          _passwordController.text = savedPassword;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Previous login details loaded.'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                setState(() {
                  _loginController.clear();
                  _passwordController.clear();
                });
              },
            ),
          ),
        );
      }
    } catch (e) {
      // Handle any errors in retrieving encrypted data
      print('Error loading credentials: \$e');
    }
  }

  void _validateLogin() {
    setState(() {
      if (_passwordController.text == "QWERTY123") {
        imageSource = "images/light-bulb.png";
      } else {
        imageSource = "images/stop-sign.png";
      }
    });

    _showSaveDialog();
  }

  void _showSaveDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Login?'),
          content: const Text('Would you like to save your username and password for next time?'),
          actions: [
            TextButton(
              onPressed: () {
                _clearCredentials();
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                _saveCredentials();
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveCredentials() async {
    try {
      await _encryptedPrefs.setString('login', _loginController.text);
      await _encryptedPrefs.setString('password', _passwordController.text);
    } catch (e) {
      print('Error saving credentials: \$e');
    }
  }

  Future<void> _clearCredentials() async {
    try {
      await _encryptedPrefs.remove('login');
      await _encryptedPrefs.remove('password');
    } catch (e) {
      print('Error clearing credentials: \$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Demo Home Page"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _loginController,
                  decoration: const InputDecoration(
                    labelText: "Login",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _validateLogin,
                  child: const Text("Login"),
                ),
                const SizedBox(height: 16.0),
                Image.asset(
                  imageSource,
                  width: 300,
                  height: 300,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
