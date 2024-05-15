import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cryptofont/cryptofont.dart';
import 'package:intl/intl.dart';

class WalletPage extends StatelessWidget {
  final String address;

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
    // Mock data for assets and prices
    final List<Map<String, dynamic>> assets = [
      {'name': 'Bitcoin', 'amount': '1.25 BTC', 'price': 40000.0, 'icon': CryptoFontIcons.btc, "color" : Colors.orange},
      {'name': 'Ethereum', 'amount': '1.56 ETH', 'price': 2500.0, 'icon': CryptoFontIcons.eth,  "color" : Colors.deepPurple},
      {'name': 'Avax', 'amount': '42 AVAX', 'price': 30.0, 'icon': CryptoFontIcons.avax, "color" : Colors.red},
      {'name': 'Solana', 'amount': '20 SOL', 'price': 150.0, 'icon': CryptoFontIcons.sol, 'color': Colors.blue[900]},
      {'name': 'BNB', 'amount': '400 BNB', 'price': 300.0, 'icon': CryptoFontIcons.bnb,  "color" : Colors.yellow[700]},
      {'name': 'Avax', 'amount': '42 AVAX', 'price': 30.0, 'icon': CryptoFontIcons.avax, "color" : Colors.red},
      {'name': 'Solana', 'amount': '20 SOL', 'price': 150.0, 'icon': CryptoFontIcons.sol, 'color': Colors.blue[900]},
      {'name': 'BNB', 'amount': '400 BNB', 'price': 300.0, 'icon': CryptoFontIcons.bnb,  "color" : Colors.yellow[700]},
      {'name': 'Avax', 'amount': '42 AVAX', 'price': 30.0, 'icon': CryptoFontIcons.avax, "color" : Colors.red},
      {'name': 'Solana', 'amount': '20 SOL', 'price': 150.0, 'icon': CryptoFontIcons.sol, 'color': Colors.blue[900]},
      {'name': 'BNB', 'amount': '400 BNB', 'price': 300.0, 'icon': CryptoFontIcons.bnb,  "color" : Colors.yellow[700]},
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Crypto Wallet'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.white, // Set the background color of the entire screen
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: const Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Text(
                        truncateAddress(address),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis, // Truncate the address text
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 60),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: const Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: const Text(
                        '0 CRP',
                        style: TextStyle(
                          color: Colors.black,
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
                        ElevatedButton(
                          onPressed: () {
                            // Deposit action
                          },
                          child: const Text('DEPOSIT'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Withdrawal action
                          },
                          child: const Text('WITHDRAWAL'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        )
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
                        color: Colors.black,
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
                              double amount = double.tryParse(asset['amount'].split(' ')[0]) ?? 0.0;
                              double value = amount * asset['price'];
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
                                        offset: const Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(asset['icon'], color: asset["color"], size: 24),
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
                                                '\$${formatPrice(asset['price'])}',
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
