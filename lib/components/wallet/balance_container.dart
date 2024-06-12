import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/price_controller.dart';
import 'chain_dropdown.dart';
import '../../styles/style.dart';
import 'package:intl/intl.dart';

class BalanceContainer extends StatelessWidget {
  final double totalValue;
  final String address; // Add address parameter

  BalanceContainer({required this.totalValue, required this.address}); // Update constructor

  String formatPrice(double price) {
    final NumberFormat formatter = NumberFormat('#,##0.00', 'en_US');
    return formatter.format(price);
  }

  @override
  Widget build(BuildContext context) {
    final PriceController priceController = Get.find();

    return Container(
      padding: const EdgeInsets.all(20.0),
      margin: const EdgeInsets.all(20.0),
      decoration: AppStyles.bottomRoundedDecoration(),
      child: Stack(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ChainDropdown(address: address), // Include ChainDropdown with address
                  const SizedBox(width: 50),
                  const SizedBox(width: 50),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 60),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Total Balance',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    priceController.prices.isNotEmpty
                        ? Text(
                      '\$${formatPrice(totalValue)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    )
                        : CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ],
      ),
    );
  }
}
