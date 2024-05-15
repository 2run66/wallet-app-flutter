import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_deneme/screens/create_wallet_screen.dart';

class ShowMnemonicScreen extends StatelessWidget {
  final String mnemonic;

  ShowMnemonicScreen({required this.mnemonic});

  @override
  Widget build(BuildContext context) {
    final mnemonicWords = mnemonic.split(" ");

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Mnemonic Phrase'),
      ),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Your Mnemonic Phrase',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Pick mnemonic phrases in order as you saved',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontFamily: 'Roboto', // Using a modern font
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: List.generate(mnemonicWords.length, (index) {
                      return Container(
                        width: 100, // Fixed width for each box
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Text(
                          '${index + 1}. ${mnemonicWords[index]}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }),
                  ),
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
              child: OutlinedButton(
                onPressed: () {
                  Get.to(() => CreateWalletScreen());
                },
                child: const Text(
                  "Done",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue.withOpacity(0.5)),
                  side: MaterialStateProperty.all(const BorderSide(color: Colors.blue, width: 2.0)),
                  padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
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
