import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';

class PasswordGeneratorScreen extends StatefulWidget {
  @override
  _PasswordGeneratorScreenState createState() =>
      _PasswordGeneratorScreenState();
}

class _PasswordGeneratorScreenState extends State<PasswordGeneratorScreen> {
  TextEditingController lengthController = TextEditingController(text: '8');
  String generatedPassword = '';
  List<String> additionalPasswords = [];
  double passwordLength = 8;
  bool includeLetters = true;
  bool includeNumbers = true;
  bool includeSpecialChars = true;
  bool showAdditionalOptions = false;

  void generatePassword() {
    final length = passwordLength.toInt();
    if (length <= 0 ||
        (!includeLetters && !includeNumbers && !includeSpecialChars)) {
      showSnackbar('Please select valid options', Colors.red);
      return;
    }
    final password = _generateRandomPassword(length);
    setState(() {
      generatedPassword = password;
      additionalPasswords.clear(); // Clear previous additional passwords
      showAdditionalOptions = false; // Reset to hide additional options
    });
  }

  void generateAdditionalPasswords() {
    additionalPasswords.clear();
    for (int i = 0; i < 2; i++) {
      final password = _generateRandomPassword(passwordLength.toInt());
      setState(() {
        additionalPasswords.add(password);
        showAdditionalOptions = true; // Show additional options
      });
    }
  }

  String _generateRandomPassword(int length) {
    const letters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    const specialChars = '!@#%^&*()_+=,<>?/{}[]|\\:;"\'`~';
    String chars = '';
    if (includeLetters) chars += letters;
    if (includeNumbers) chars += numbers;
    if (includeSpecialChars) chars += specialChars;

    final random = Random();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  void copyToClipboard(String password) {
    final data = ClipboardData(text: password);
    Clipboard.setData(data);
    showSnackbar('Password copied to clipboard', Colors.green);
  }

  void clearFields() {
    setState(() {
      generatedPassword = '';
      additionalPasswords.clear();
      passwordLength = 8;
      includeLetters = false;
      includeNumbers = false;
      includeSpecialChars = false;
      showAdditionalOptions = false; // Reset to hide additional options
    });
  }

  void toggleAdditionalOptions() {
    setState(() {
      showAdditionalOptions = !showAdditionalOptions;
      if (showAdditionalOptions) {
        generateAdditionalPasswords();
      } else {
        additionalPasswords.clear();
      }
    });
  }

  void showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Password Generator',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Length: ${passwordLength.toInt()}'),
              Slider(
                value: passwordLength,
                min: 4,
                max: 32,
                divisions: 28,
                label: passwordLength.round().toString(),
                onChanged: (value) {
                  setState(() {
                    passwordLength = value;
                  });
                },
                activeColor: Colors.red,
                inactiveColor: Colors.red.withOpacity(0.3),
              ),
              CheckboxListTile(
                title: Text('Include Letters'),
                value: includeLetters,
                activeColor: Colors.red,
                onChanged: (value) {
                  setState(() {
                    includeLetters = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Include Numbers'),
                value: includeNumbers,
                activeColor: Colors.red,
                onChanged: (value) {
                  setState(() {
                    includeNumbers = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Include Special Characters'),
                value: includeSpecialChars,
                activeColor: Colors.red,
                onChanged: (value) {
                  setState(() {
                    includeSpecialChars = value!;
                  });
                },
              ),
              SizedBox(height: 16),
              if (generatedPassword.isNotEmpty) ...[
                Text(
                  'Your Password is :',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      generatedPassword,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.0),
                    ),
                    IconButton(
                      icon: Icon(Icons.copy, color: Colors.red),
                      onPressed: () => copyToClipboard(generatedPassword),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: toggleAdditionalOptions,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: Size(150, 48),
                  ),
                  child: Text(showAdditionalOptions ? 'Hide Options' : 'Show Options'),
                ),
                if (showAdditionalOptions && additionalPasswords.isNotEmpty) ...[
                  SizedBox(height: 16),
                  Text(
                    'Additional Passwords Options:',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Column(
                    children: additionalPasswords.map((password) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            password,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0),
                          ),
                          IconButton(
                            icon: Icon(Icons.copy, color: Colors.red),
                            onPressed: () => copyToClipboard(password),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                ],
              ],
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: generatePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: Size(150, 48),
                ),
                child: Text('Generate'),
              ),
              ElevatedButton(
                onPressed: clearFields,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: Size(150, 48),
                ),
                child: Text('Clear'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
