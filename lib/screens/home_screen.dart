// home_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_deneme/screens/import_wallet_screen.dart';
import 'package:getx_deneme/screens/show_mnemonic_screen.dart';
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
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Wallet App'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  // Navigate to the screen for importing an existing wallet
                  Get.to(() => ImportWalletScreen());
                },
                child: const Text('Import Your Wallet'),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Create a new wallet and navigate to the next screen
                  generateWallet();
                  debugPrint('address: $_address');
                  Get.to(() => ShowMnemonicScreen(mnemonic: _mnemonic));
                },
                child: const Text('Create a New Wallet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
