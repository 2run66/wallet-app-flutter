import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_deneme/screens/import_wallet_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'wallet_screen.dart';
import 'home_screen.dart'; // Import the new HomeScreen file
import '../styles/style.dart'; // Import the styles file

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final String _mockPassword = '669700';
  String _enteredPassword = '';
  String _errorMessage = 'Please Enter Your Password';

  @override
  void initState() {
    super.initState();
    _checkCredentials();
  }

  void _checkCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? address = prefs.getString('address');
    List<String>? mnemonic = prefs.getStringList('mnemonic');

    if (address == null || mnemonic == null) {
      Get.offAll(() => const MyHomePage(title: 'Flutter Demo Home Page'));
    }
  }

  void _checkPassword() async {
    if (_enteredPassword == _mockPassword) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? address = prefs.getString('address');
      if (address != null) {
        Get.offAll(() => WalletPage(address: address));
      }
    } else {
      setState(() {
        _errorMessage = 'Incorrect password. Please try again.';
        _enteredPassword = ''; // Reset the entered password
      });
    }
  }

  void _onKeyPressed(String value) {
    setState(() {
      if (value == 'C') {
        _enteredPassword = '';
        _errorMessage = 'Please Enter Your Password';
      } else if (value == 'Enter') {
        _checkPassword();
      } else {
        if (_enteredPassword.length < 6) {
          _enteredPassword += value;
          if (_enteredPassword.length == 6) {
            _checkPassword();
          }
        }
      }
    });
  }

  String _getDisplayPassword() {
    return '*' * _enteredPassword.length + ' ' * (6 - _enteredPassword.length);
  }

  void _onForgotPassword() {
    Get.to(() => ImportWalletScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1C1C1C), Color(0xFF000000)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.4),
                      offset: Offset(0, -3),
                      blurRadius: 50,
                      spreadRadius: 5,
                    ),
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.4),
                      offset: Offset(0, 3),
                      blurRadius: 50,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Image.asset('assets/wallet-icon.png', height: 180),
              ),
              const SizedBox(height: 50),
              Text(
                "Welcome Back",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                _errorMessage,
                style: TextStyle(color: _errorMessage == 'Please Enter Your Password' ? Colors.grey : Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterText: '',
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _enteredPassword = value;
                      if (_enteredPassword.length == 6) {
                        _checkPassword();
                      }
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (_enteredPassword.length == 6) {
                    _checkPassword();
                  }
                },
                child: Text('Unlock', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20),
              const Text(
                "Use Biometric Authentication",
                style: TextStyle(color: Colors.blueAccent),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _onForgotPassword,
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class AppStyles {
  static const Color backgroundColor = Color(0xFF1C1C1C);

  static TextStyle greyTextStyle(double fontSize) {
    return TextStyle(
      color: Colors.grey,
      fontSize: fontSize,
    );
  }

  static TextStyle neonTextStyle(double fontSize, Color color) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      shadows: [
        Shadow(
          blurRadius: 10.0,
          color: color,
          offset: Offset(0, 0),
        ),
      ],
    );
  }

  static BoxDecoration keypadContainerDecoration() {
    return BoxDecoration(
      color: Colors.black.withOpacity(0.1),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(0, 1),
        ),
      ],
    );
  }
}
