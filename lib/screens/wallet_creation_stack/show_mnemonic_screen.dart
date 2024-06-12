import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_deneme/screens/wallet_creation_stack/create_wallet_screen.dart';

class ShowMnemonicScreen extends StatelessWidget {
  final String mnemonic;

  ShowMnemonicScreen({required this.mnemonic});

  @override
  Widget build(BuildContext context) {
    final mnemonicWords = mnemonic.split(" ");

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Spacer(flex: 2), // Adding Spacer to push the logo and mnemonic upwards
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
                  const SizedBox(height: 40.0), // Adjusted spacing
                  const Text(
                    'Your Mnemonic Phrase',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Save mnemonic phrases in a secure way!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontFamily: 'Roboto', // Using a modern font
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30), // Adjusted spacing
                  Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: List.generate(mnemonicWords.length, (index) {
                      return Container(
                        width: 100, // Fixed width for each box
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, -3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Text(
                          '${index + 1}. ${mnemonicWords[index]}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }),
                  ),
                  Spacer(flex: 4), // Adding Spacer to maintain the button position at the bottom
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.90, // 90% of the screen width
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => CreateWalletScreen());
                },
                child: const Text(
                  "Done",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
