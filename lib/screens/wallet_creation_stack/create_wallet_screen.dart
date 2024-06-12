import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/main_controller.dart';
import '../wallet_stack/wallet_screen.dart';
import 'create_password_screen.dart'; // Import the CreatePasswordScreen

class CreateWalletScreen extends StatelessWidget {
  CreateWalletScreen({super.key});
  final MainController _mainController = Get.find();
  final RxMap<String, int> _selectedMnemonicOrder = <String, int>{}.obs;

  @override
  Widget build(BuildContext context) {
    // Shuffle the mnemonic list
    List<String> _mnemonic = List<String>.from(_mainController.mnemonic.value)..shuffle(Random());

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
                  Spacer(flex: 2),
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
                  const SizedBox(height: 40.0),
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
                    child: Text(
                      "Address\n ${_mainController.address.value}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Roboto', // Using a modern font
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Pick mnemonic phrases in order as you saved',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontFamily: 'Roboto', // Using a modern font
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 50),
                  Obx(() => Wrap(
                    spacing: 8.0, // gap between adjacent chips
                    runSpacing: 4.0, // gap between lines
                    alignment: WrapAlignment.center, // Center align the wrap
                    children: _mnemonic.map((item) {
                      int? order = _selectedMnemonicOrder[item];
                      return FilterChip(
                        label: Text(
                          item,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        selected: order != null,
                        onSelected: (bool selected) {
                          if (selected) {
                            if (!_selectedMnemonicOrder.containsKey(item)) {
                              _selectedMnemonicOrder[item] = _selectedMnemonicOrder.length + 1;
                            }
                          } else {
                            int? removedOrder = _selectedMnemonicOrder.remove(item);
                            if (removedOrder != null) {
                              _selectedMnemonicOrder.forEach((key, value) {
                                if (value > removedOrder) {
                                  _selectedMnemonicOrder[key] = value - 1;
                                }
                              });
                              _selectedMnemonicOrder.refresh();
                            }
                          }
                        },
                        backgroundColor: Colors.grey[800],
                        selectedColor: Colors.blue.withOpacity(1),
                        showCheckmark: false, // Disable the checkmark
                        avatar: order != null
                            ? CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Text(
                            order.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        )
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15), // Match the button's border radius
                          side: BorderSide(
                              color: order != null ? Colors.blue : Colors.transparent, // Apply blue border when selected
                              width: 2.0 // Match the button's border width
                          ),
                        ),
                      );
                    }).toList(),
                  )),
                  IconButton(
                    icon: Icon(Icons.refresh, color: Colors.blue),
                    onPressed: () {
                      _selectedMnemonicOrder.clear();
                    },
                  ),
                  Spacer(flex: 3),
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
                  _confirmMnemonicOrder(context, List<String>.from(_mainController.mnemonic.value));
                },
                child: const Text(
                  "Confirm",
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

  void _confirmMnemonicOrder(BuildContext context, List<String> correctOrder) async {
    List<String> userOrder = List<String>.filled(correctOrder.length, "", growable: false);
    _selectedMnemonicOrder.forEach((key, value) {
      userOrder[value - 1] = key;
    });

    bool isCorrect = userOrder.every((item) => correctOrder.contains(item)) &&
        userOrder.asMap().entries.every((entry) => entry.value == correctOrder[entry.key]);

    if (isCorrect) {
      await _saveToLocalStorage(_mainController.address.value, userOrder);
      Get.to(() => CreatePasswordScreen());
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Incorrect'),
            content: const Text('The mnemonic order is incorrect.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _saveToLocalStorage(String address, List<String> mnemonic) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('address', address);
    await prefs.setStringList('mnemonic', mnemonic);
  }
}
