import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_deneme/screens/wallet_creation_stack/import_wallet_screen.dart';
import 'package:getx_deneme/screens/wallet_creation_stack/show_mnemonic_screen.dart';
import 'package:getx_deneme/services/derive_path.dart';
import 'package:getx_deneme/services/generate_address.dart';
import 'package:getx_deneme/services/generate_seed.dart';
import 'package:getx_deneme/controllers/main_controller.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _mainController = Get.put(MainController());
  String _mnemonic = "";
  String _address = "";

  void generateWallet() {
    _mnemonic = generateMnemonic();
    _mainController.setMnemonic(_mnemonic.split(" "));
    var key = deriveKey(_mnemonic);
    _address = publicKeyToAddress(key.publicKey);
    _mainController.setAddress(_address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
              const SizedBox(height: 60.0),
              const Text(
                "Welcome to Quista Wallet",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 0),
                      blurRadius: 7.0,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                ),
                onPressed: () {
                  // Navigate to the screen for importing an existing wallet
                  Get.to(() => ImportWalletScreen());
                },
                child: const Text(
                  'Import Your Wallet',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                ),
                onPressed: () {
                  // Create a new wallet and navigate to the next screen
                  generateWallet();
                  debugPrint('address: $_address');
                  Get.to(() => ShowMnemonicScreen(mnemonic: _mnemonic));
                },
                child: const Text(
                  'Create a New Wallet',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
