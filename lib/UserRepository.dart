import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class UserRepository {
  final EncryptedSharedPreferences _encryptedPrefs = EncryptedSharedPreferences();

  String firstName = '';
  String lastName = '';
  String phoneNumber = '';
  String email = '';

  // Load data from encrypted shared preferences
  Future<void> loadData() async {
    firstName = await _encryptedPrefs.getString('firstName') ?? '';
    lastName = await _encryptedPrefs.getString('lastName') ?? '';
    phoneNumber = await _encryptedPrefs.getString('phoneNumber') ?? '';
    email = await _encryptedPrefs.getString('email') ?? '';
  }

  // Save data to encrypted shared preferences
  Future<void> saveData() async {
    await _encryptedPrefs.setString('firstName', firstName);
    await _encryptedPrefs.setString('lastName', lastName);
    await _encryptedPrefs.setString('phoneNumber', phoneNumber);
    await _encryptedPrefs.setString('email', email);
  }
}