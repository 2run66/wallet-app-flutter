import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/main_controller.dart';

class SecondScreen extends StatelessWidget {
  SecondScreen({super.key});
  final MainController _mainController = Get.find();
  final RxMap<String, int> _selectedMnemonicOrder = <String, int>{}.obs;

  @override
  Widget build(BuildContext context) {
    List<String> _mnemonic = List<String>.from(_mainController.mnemonic.value);
    return Scaffold(
      appBar: AppBar(
        title: Text("Wallet"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("Address: ${_mainController.address.value}"),
            const SizedBox(height: 40),
            Obx(() => Wrap(
              spacing: 8.0, // gap between adjacent chips
              runSpacing: 4.0, // gap between lines
              children: _mnemonic.map((item) {
                int? order = _selectedMnemonicOrder[item];
                return FilterChip(
                  label: Text(item, style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
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
                  backgroundColor: Colors.grey[200],
                  selectedColor: Colors.blue.withOpacity(0.5),
                  showCheckmark: false, // Disable the checkmark
                  avatar: order != null ? CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Text(
                      order.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ) : null,
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
            const SizedBox(height: 360),

            Container(
              width: MediaQuery.of(context).size.width * 0.90, // 75% of the screen width
              child: OutlinedButton(
                onPressed: () => debugPrint("Confirmed"),
                child: Text(
                  "Confirm",
                  style: TextStyle(
                    color: Colors.black, // Assuming the text color in the selected FilterChip is white
                    fontSize: 15,
                    fontWeight: FontWeight.bold// Match the font size to the FilterChip
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue.withOpacity(0.5)), // Same as the selected FilterChip color
                  side: MaterialStateProperty.all(BorderSide(color: Colors.blue, width: 2.0)), // Match the border color and width
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 15, horizontal: 20)), // Adjust padding if needed
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Adjust the border radius if needed
                    ),
                  ),
                ),
              ),
            )


          ],
        ),
      ),

    );
  }
}