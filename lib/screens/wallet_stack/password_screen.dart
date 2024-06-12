import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for the utf8.encode method
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart'; // Import this for PlatformException

import 'wallet_screen.dart';
import '../wallet_creation_stack/wallet_home_screen.dart'; // Import the new HomeScreen file
import '../wallet_creation_stack/import_wallet_screen.dart'; // Import the ImportWalletScreen file
import '../../styles/style.dart'; // Import the styles file

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  String _enteredPassword = '';
  String _errorMessage = 'Please Enter Your Password';
  bool _showBiometricButton = false;
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _checkCredentials();
    _loadBiometricPreference();
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedPasswordHash = prefs.getString('password_hash');

    if (storedPasswordHash != null) {
      String enteredPasswordHash = sha256.convert(utf8.encode(_enteredPassword)).toString();

      if (enteredPasswordHash == storedPasswordHash) {
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
  }

  Future<void> _loadBiometricPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? useBiometrics = prefs.getBool('use_biometrics');
    if (useBiometrics != null && useBiometrics) {
      setState(() {
        _showBiometricButton = true;
      });
      _checkBiometrics();
    }
  }

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics = await auth.canCheckBiometrics;
    if (canCheckBiometrics) {
      _authenticate();
    }
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to unlock your wallet',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('use_biometrics', true);
        String? address = prefs.getString('address');
        if (address != null) {
          Get.offAll(() => WalletPage(address: address));
        }
      } else {
        setState(() {
          _errorMessage = 'Biometric authentication failed';
        });
      }
    } on PlatformException catch (e) {
      if (e.code == 'NotAvailable') {
        setState(() {
          _errorMessage = 'You don\'t have any biometric authentication set up';
        });
      } else {
        setState(() {
          _errorMessage = 'Error: ${e.message}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });
    }
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
              const SizedBox(height: 20),
              Text(
                _errorMessage,
                style: TextStyle(color: _errorMessage == 'Please Enter Your Password' ? Colors.grey : Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
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
              if (_showBiometricButton)
                GestureDetector(
                  onTap: _authenticate,
                  child: const Text(
                    "Use Biometric Authentication",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              if (!_showBiometricButton)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showBiometricButton = true;
                      _checkBiometrics();
                    });
                  },
                  child: const Text(
                    "Enable Biometric Authentication",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
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
