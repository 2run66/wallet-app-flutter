import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:cryptofont/cryptofont.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../styles/style.dart';
import '../controllers/price_controller.dart';
import '../components/asset_item.dart';
import '../components/nft_item.dart';

class WalletPage extends StatelessWidget {
  final String address;
  final PriceController priceController = Get.put(PriceController());
  final RxInt activeTab = 0.obs;
  final GlobalKey _tokensKey = GlobalKey();
  final GlobalKey _nftsKey = GlobalKey();

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

  String formatChangePercentage(double change) {
    return '${change.toStringAsFixed(2)}%';
  }

  double calculateTotalValue(List<Map<String, dynamic>> assets, Map<String, double> prices) {
    double total = 0.0;
    for (var asset in assets) {
      double amount = double.tryParse(asset['amount'].split(' ')[0]) ?? 0.0;
      double currentPrice = prices[asset['symbol']] ?? asset['price'];
      total += amount * currentPrice;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> assets = [
      {'name': 'Bitcoin', 'amount': '1.25 BTC', 'symbol': 'btcusdt', 'price': 0.0, 'icon': CryptoFontIcons.btc, 'color': Colors.orange},
      {'name': 'Ethereum', 'amount': '1.56 ETH', 'symbol': 'ethusdt', 'price': 0.0, 'icon': CryptoFontIcons.eth, 'color': Colors.deepPurple},
      {'name': 'Avax', 'amount': '42 AVAX', 'symbol': 'avaxusdt', 'price': 0.0, 'icon': CryptoFontIcons.avax, 'color': Colors.red},
      {'name': 'Solana', 'amount': '20 SOL', 'symbol': 'solusdt', 'price': 0.0, 'icon': CryptoFontIcons.sol, 'color': Colors.blue[900]},
      {'name': 'BNB', 'amount': '400 BNB', 'symbol': 'bnbusdt', 'price': 0.0, 'icon': CryptoFontIcons.bnb, 'color': Colors.yellow[700]},
    ];

    final List<Map<String, dynamic>> nfts = [
      {'name': 'Magical', 'image': 'assets/pen-magical.jpg', 'creator': 'Larva Labs'},
      {'name': 'Legendary', 'image': 'assets/pen-legendary.jpg', 'creator': 'Yuga Labs'},
      {'name': 'Gold', 'image': 'assets/pen-gold.jpg', 'creator': 'Art Blocks'},
      {'name': 'Silver', 'image': 'assets/pen-silver.jpg', 'creator': 'Larva Labs'},
      {'name': 'Wood', 'image': 'assets/pen-wood.jpg', 'creator': 'Yuga Labs'},
      {'name': 'Magical', 'image': 'assets/pen-magical.jpg', 'creator': 'Larva Labs'},
      {'name': 'Legendary', 'image': 'assets/pen-legendary.jpg', 'creator': 'Yuga Labs'},
      {'name': 'Gold', 'image': 'assets/pen-gold.jpg', 'creator': 'Art Blocks'},
      {'name': 'Silver', 'image': 'assets/pen-silver.jpg', 'creator': 'Larva Labs'},
      {'name': 'Wood', 'image': 'assets/pen-wood.jpg', 'creator': 'Yuga Labs'},

      // Add more NFT data here
    ];

    return Scaffold(
      body: Obx(() {
        if (!priceController.isConnected.value) {
          return Center(child: CircularProgressIndicator());
        }

        double totalValue = calculateTotalValue(assets, priceController.prices);
        return Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF232323),
                Colors.black
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: [0.0, 1.0],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  margin: const EdgeInsets.all(20.0),
                  decoration: AppStyles.bottomRoundedDecoration(),
                  child: Column(
                    children: [
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
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Withdrawal action
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 10),
                                  shape: const CircleBorder(),
                                  backgroundColor: Colors.black.withOpacity(0.5),
                                ),
                                child: const Icon(FontAwesomeIcons.arrowUp, size: 30, color: Colors.white),
                              ),
                              Text(
                                "Send",
                                style: AppStyles.whiteTextStyle(16, FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(width: 20), // Increased spacing between buttons
                          Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Withdrawal action
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 10),
                                  shape: const CircleBorder(),
                                  backgroundColor: Colors.black.withOpacity(0.5),
                                ),
                                child: const Icon(FontAwesomeIcons.arrowDown, size: 30, color: Colors.white),
                              ),
                              Text(
                                "Withdraw",
                                style: AppStyles.whiteTextStyle(16, FontWeight.w600),
                              ),
                            ],
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
                      Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buildTabButton(context, 0, 'Tokens', _tokensKey),
                              const SizedBox(width: 40), // Increased spacing between tab buttons
                              buildTabButton(context, 1, 'NFTs', _nftsKey),
                            ],
                          ),
                          Obx(() {
                            double buttonWidth = 0;
                            double buttonLeft = 0;
                            if (_tokensKey.currentContext != null && _nftsKey.currentContext != null) {
                              buttonWidth = activeTab.value == 0
                                  ? (_tokensKey.currentContext!.findRenderObject() as RenderBox).size.width
                                  : (_nftsKey.currentContext!.findRenderObject() as RenderBox).size.width;
                              buttonLeft = activeTab.value == 0
                                  ? (_tokensKey.currentContext!.findRenderObject() as RenderBox).localToGlobal(Offset.zero).dx
                                  : (_nftsKey.currentContext!.findRenderObject() as RenderBox).localToGlobal(Offset.zero).dx;
                            }
                            return AnimatedPositioned(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              left: buttonLeft - 20, // Adjust to align the line properly
                              bottom: 0,
                              child: Container(
                                height: 3,
                                width: buttonWidth,
                                decoration: BoxDecoration(
                                  color: Colors.pinkAccent,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.pinkAccent.withOpacity(0.4),
                                      blurRadius: 8,
                                      spreadRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Obx(() => AnimatedCrossFade(
                        firstChild: priceController.prices.isNotEmpty
                            ? buildAssetsList(context, assets)
                            : Center(
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[700]!.withOpacity(0.5),
                            highlightColor: Colors.grey[500]!.withOpacity(0.5),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.5,
                              decoration: BoxDecoration(
                                color: Colors.grey[700]!.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        secondChild: buildNftsGrid(context, nfts),
                        crossFadeState: activeTab.value == 0
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: const Duration(milliseconds: 300),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget buildTabButton(BuildContext context, int index, String title, GlobalKey key) {
    return GestureDetector(
      onTap: () {
        activeTab.value = index;
      },
      child: Obx(() => Container(
        key: key,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Text(
          title,
          style: TextStyle(
            color: activeTab.value == index ? Colors.pinkAccent : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            shadows: activeTab.value == index
                ? [
              Shadow(
                blurRadius: 30,
                color: Colors.pinkAccent,
                offset: const Offset(0, 0),
              ),
            ]
                : null,
          ),
        ),
      )),
    );
  }

  Widget buildAssetsList(BuildContext context, List<Map<String, dynamic>> assets) {
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
              double currentPrice = priceController.prices[asset['symbol']] ?? asset['price'];
              double changePercentage = priceController.changePercentages[asset['symbol']] ?? 0.0;
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

  Widget buildNftsGrid(BuildContext context, List<Map<String, dynamic>> nfts) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      child: GridView.builder(
        padding: const EdgeInsets.all(5.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7, // Adjust to fit your design needs
        ),
        itemCount: nfts.length,
        itemBuilder: (context, index) {
          return NftItem(nft: nfts[index]);
        },
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
