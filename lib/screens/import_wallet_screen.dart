import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/main_controller.dart';

import 'package:getx_deneme/screens/create_wallet_screen.dart';
import 'package:getx_deneme/services/derive_path.dart';
import 'package:getx_deneme/services/generate_address.dart';
import 'package:getx_deneme/services/generate_seed.dart';

class ImportWalletScreen extends StatelessWidget {
  final List<TextEditingController> _mnemonicControllers =
      List.generate(12, (_) => TextEditingController());
  final MainController _mainController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import Wallet'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Center(
                child: Text(
              'Enter Your Mnemonic Phrases',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),
            )),
            const SizedBox(height: 50.0),
            GridView.builder(
              shrinkWrap: true,
              // Use shrinkWrap to make GridView take only the necessary space
              physics: const NeverScrollableScrollPhysics(),
              // Disable GridView's own scrolling
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3,
                // Adjust the aspect ratio to make boxes larger
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    SizedBox(
                      width: 22, // Fixed width for the label
                      child: Text('${index + 1}.'),
                    ),
                    const SizedBox(width: 1),
                    Expanded(
                      child: TextField(
                        controller: _mnemonicControllers[index],
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical:
                                  15), // Adjust vertical padding to center text
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Implement the logic for importing a wallet using the mnemonic phrase
                  String mnemonic = _mnemonicControllers
                      .map((controller) => controller.text)
                      .join(" ");
                  var key = deriveKey(mnemonic);
                  String address = publicKeyToAddress(key.publicKey);
                  // Set the imported mnemonic and address in the main controller
                  _mainController.setMnemonic(mnemonic.split(" "));
                  _mainController.setAddress(address);
                  // Navigate to the next screen
                  Get.to(() => CreateWalletScreen());
                },
                child: const Text('Import Wallet'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
