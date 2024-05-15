import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cryptofont/cryptofont.dart';
import 'package:intl/intl.dart';
import 'package:getx_deneme/controllers/price_controller.dart';
import '../styles/style.dart';

class WalletPage extends StatelessWidget {
  final String address;
  final PriceController priceController = Get.put(PriceController());

  WalletPage({required this.address});

  String truncateAddress(String address, {int startLength = 10, int endLength = 10}) {
    if (address.length <= startLength + endLength) {
      return address;
    }
    return '${address.substring(0, startLength)}...${address.substring(address.length - endLength)}';
  }

  String formatPrice(double price) {
    final NumberFormat formatter = NumberFormat('#,##0.00', 'en_US');
    return formatter.format(price);
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> assets = [
      {'name': 'Bitcoin', 'amount': '1.25 BTC', 'price': 40000.0, 'icon': CryptoFontIcons.btc, 'color': Colors.orange},
      {'name': 'Ethereum', 'amount': '1.56 ETH', 'price': 2500.0, 'icon': CryptoFontIcons.eth, 'color': Colors.deepPurple},
      {'name': 'Avax', 'amount': '42 AVAX', 'price': 30.0, 'icon': CryptoFontIcons.avax, 'color': Colors.red},
      {'name': 'Solana', 'amount': '20 SOL', 'price': 150.0, 'icon': CryptoFontIcons.sol, 'color': Colors.blue[900]},
      {'name': 'BNB', 'amount': '400 BNB', 'price': 300.0, 'icon': CryptoFontIcons.bnb, 'color': Colors.yellow[700]},
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Crypto Wallet', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppStyles.backgroundColor,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppStyles.backgroundColor, AppStyles.secondaryColor],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                margin: const EdgeInsets.all(20.0),
                decoration: AppStyles.bottomRoundedDecoration(),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        color: Colors.black.withOpacity(0.3),
                      ),
                      child: Text(
                        truncateAddress(address),
                        style: AppStyles.whiteTextStyle(18, FontWeight.bold),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 60),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '0 CRP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () {
                              // Deposit action
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              backgroundColor: AppStyles.primaryColor,
                            ),
                            child: Text('DEPOSIT', style: AppStyles.buttonTextStyle()),
                          ),
                        ),
                        const SizedBox(width: 10), // Add spacing between buttons
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () {
                              // Withdrawal action
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              backgroundColor: AppStyles.primaryColor,
                            ),
                            child: Text('WITHDRAWAL', style: AppStyles.buttonTextStyle()),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Assets',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.5,
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(5.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Column(
                            children: assets.map((asset) {
                              return Obx(() {
                                double price = priceController.prices[asset['symbol']] ?? 0.0;
                                double amount = double.tryParse(asset['amount'].split(' ')[0]) ?? 0.0;
                                double value = amount * price;

                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.white, width: 1),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.15),
                                          spreadRadius: 1,
                                          blurRadius: 3,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(asset['icon'], color: asset['color'], size: 24),
                                            const SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  asset['name'],
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  '\$${formatPrice(price)}',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontStyle: FontStyle.italic,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              asset['amount'],
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              '\$${formatPrice(value)}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                              return AssetItem(asset: asset, formatPrice: formatPrice);
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AssetItem extends StatelessWidget {
  final Map<String, dynamic> asset;
  final String Function(double) formatPrice;

  const AssetItem({required this.asset, required this.formatPrice});

  @override
  Widget build(BuildContext context) {
    double amount = double.tryParse(asset['amount'].split(' ')[0]) ?? 0.0;
    double value = amount * asset['price'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: AppStyles.assetContainerDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(asset['icon'], color: asset['color'], size: 24),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      asset['name'],
                      style: AppStyles.whiteTextStyle(16, FontWeight.bold),
                    ),
                    Text(
                      '\$${formatPrice(asset['price'])}',
                      style: AppStyles.greyTextStyle(14, FontStyle.italic),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  asset['amount'],
                  style: AppStyles.whiteTextStyle(16),
                ),
                Text(
                  '\$${formatPrice(value)}',
                  style: AppStyles.greyTextStyle(14, FontStyle.italic),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Crypto Wallet',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WalletPage(
        address: '0x0effsadad79756',
      ),
    );
  }
}