import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Add this import
import '../../controllers/price_controller.dart';
import 'asset_item.dart';

class AssetsListView extends StatelessWidget {
  final List<Map<String, dynamic>> assets;

  AssetsListView({required this.assets});

  String formatPrice(double price) {
    final NumberFormat formatter = NumberFormat('#,##0.00', 'en_US');
    return formatter.format(price);
  }

  String formatChangePercentage(double change) {
    return '${change.toStringAsFixed(2)}%';
  }

  @override
  Widget build(BuildContext context) {
    final PriceController priceController = Get.find();

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(5.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Column(
            children: assets.map((asset) {
              String symbol = asset['symbol'].toLowerCase() + 'usdt'; // Append 'usdt' to match the WebSocket data
              double currentPrice = priceController.prices[symbol] ?? asset['price'];
              double changePercentage = priceController.changePercentages[symbol] ?? 0.0;
              return AssetItem(
                asset: asset,
                formatPrice: formatPrice,
                currentPrice: currentPrice,
                changePercentage: changePercentage,
                formatChangePercentage: formatChangePercentage,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
