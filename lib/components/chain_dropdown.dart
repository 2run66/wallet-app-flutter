import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cryptofont/cryptofont.dart';
import '../controllers/chain_controller.dart';
import '../models/chain_model.dart';

class ChainDropdown extends StatelessWidget {
  final String address;
  final ChainController chainController = Get.find<ChainController>();

  ChainDropdown({required this.address});

  IconData getChainIcon(String symbol) {
    switch (symbol.toLowerCase()) {
      case 'eth':
        return CryptoFontIcons.eth;
      case 'sol':
        return CryptoFontIcons.sol;
      case 'avax':
        return CryptoFontIcons.avax;
      case 'bnb':
        return CryptoFontIcons.bnb;
      default:
        return CryptoFontIcons.eth;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DropdownButtonHideUnderline(
        child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black.withOpacity(0.5),
        ),

        child: DropdownButton<String>(
          padding: EdgeInsets.only(right: 5),
          value: chainController.selectedChain.value.name,
          dropdownColor: Colors.black.withOpacity(0.8), // Add opacity to the dropdown
          style: TextStyle(color: Colors.white),
          icon: Icon(Icons.arrow_drop_down, color: Colors.white),
          selectedItemBuilder: (BuildContext context) {
            return chainController.chains.map((Chain chain) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                  getChainIcon(chain.symbol),
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text(chain.name, style: TextStyle(color: Colors.white)),
                ]
              );
            }).toList();
          },
          items: chainController.chains.map<DropdownMenuItem<String>>((Chain chain) {
            return DropdownMenuItem<String>(
              value: chain.name,
              child: Row(
                children: [
                  Icon(getChainIcon(chain.symbol), color: Colors.white),
                  SizedBox(width: 5),
                  Text(chain.name),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? newValue) async {
            if (newValue != null) {
              Chain selectedChain = chainController.chains.firstWhere((chain) => chain.name == newValue);
              chainController.changeChain(selectedChain, address);
              await chainController.fetchBalance(address);
            }
          },
        ),
      )
      );
    });
  }
}