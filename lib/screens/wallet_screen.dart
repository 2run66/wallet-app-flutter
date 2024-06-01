import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cryptofont/cryptofont.dart';
import '../controllers/chain_controller.dart';
import '../controllers/price_controller.dart';
import '../services/transaction_service.dart';
import '../styles/style.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../components/asset_item.dart';
import '../components/nft_item.dart';
import '../components/chain_dropdown.dart';
import 'home_screen.dart'; // Import the HomeScreen or other screens
import '../components/bottom_nav_bar.dart'; // Import the BottomNavBar component

class WalletPage extends StatefulWidget {
  final String address;

  WalletPage({required this.address});

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final PriceController priceController = Get.put(PriceController());
  final ChainController chainController = Get.put(ChainController());
  late final TransactionService transactionService;

  final RxInt activeTab = 0.obs;
  final GlobalKey _tokensKey = GlobalKey();
  final GlobalKey _nftsKey = GlobalKey();
  final RxInt _selectedIndex = 0.obs; // Changed to RxInt

  final List<Widget> _screens = [
    WalletPageContent(), // Create a separate widget for WalletPage content
    MyHomePage(title: 'Home Page'), // Replace with your actual new screen
    // Add more screens here as needed
  ];

  @override
  void initState() {
    super.initState();
    transactionService = TransactionService(rpcUrl: chainController.selectedChain.value.rpcUrls.first);
    chainController.fetchBalance(widget.address);
  }

  void _onItemTapped(int index) {
    _selectedIndex.value = index; // Use .value to update the RxInt
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _screens[_selectedIndex.value]), // Use .value to access the current value
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class WalletPageContent extends StatelessWidget {
  final RxInt activeTab = 0.obs; // Define activeTab within WalletPageContent

  @override
  Widget build(BuildContext context) {
    final PriceController priceController = Get.find();
    final ChainController chainController = Get.find();
    final GlobalKey _tokensKey = GlobalKey();
    final GlobalKey _nftsKey = GlobalKey();

    double calculateTotalValue(List<Map<String, dynamic>> assets, Map<String, double> prices) {
      double total = 0.0;
      for (var asset in assets) {
        double amount = double.tryParse(asset['amount'].split(' ')[0]) ?? 0.0;
        double currentPrice = prices[asset['symbol']] ?? asset['price'];
        total += amount * currentPrice;
      }
      return total;
    }

    List<Map<String, dynamic>> getAssets() {
      return [
        {
          'name': chainController.selectedChain.value.name,
          'amount': '${chainController.balance.value} ${chainController.selectedChain.value.symbol.toUpperCase()}',
          'symbol': chainController.selectedChain.value.symbol,
          'price': 0.0,
          'icon': getChainIcon(chainController.selectedChain.value.symbol),
          'color': Colors.orange,
        },
      ];
    }

    List<Map<String, dynamic>> getNfts() {
      return [
        {'name': 'Magical', 'image': 'assets/pen-magical.jpg', 'creator': 'Larva Labs'},
        {'name': 'Legendary', 'image': 'assets/pen-legendary.jpg', 'creator': 'Yuga Labs'},
        {'name': 'Gold', 'image': 'assets/pen-gold.jpg', 'creator': 'Art Blocks'},
        {'name': 'Silver', 'image': 'assets/pen-silver.jpg', 'creator': 'Larva Labs'},
        {'name': 'Wood', 'image': 'assets/pen-wood.jpg', 'creator': 'Yuga Labs'},
      ];
    }

    return Obx(() {
      if (!priceController.isConnected.value) {
        return Center(child: CircularProgressIndicator());
      }

      double totalValue = calculateTotalValue(getAssets(), priceController.prices);

      return Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF232323),
              Colors.black,
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            stops: [0.0, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Container(
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
                            ChainDropdown(address: ''), // Pass the address as needed
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
                      ],
                    ),
                    const SizedBox(height: 10),
                    Obx(() => AnimatedCrossFade(
                      firstChild: priceController.prices.isNotEmpty
                          ? buildAssetsList(context, getAssets())
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
                      secondChild: buildNftsGrid(context, getNfts()),
                      crossFadeState: activeTab.value == 0 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                      duration: const Duration(milliseconds: 300),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

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
        return CryptoFontIcons.btc;
    }
  }

  String formatPrice(double price) {
    final NumberFormat formatter = NumberFormat('#,##0.00', 'en_US');
    return formatter.format(price);
  }

  String formatChangePercentage(double change) {
    return '${change.toStringAsFixed(2)}%';
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
