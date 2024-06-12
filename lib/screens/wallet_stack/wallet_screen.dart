import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cryptofont/cryptofont.dart';
import '../../controllers/chain_controller.dart';
import '../../controllers/price_controller.dart';
import '../../services/transaction_service.dart';
import '../../styles/style.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../components/wallet/chain_dropdown.dart';
import '../wallet_creation_stack/wallet_home_screen.dart'; // Import the HomeScreen or other screens
import '../../components/bottom_tab/bottom_nav_bar.dart'; // Import the BottomNavBar component
import '../../components/wallet/balance_container.dart'; // Import the BalanceContainer component
import '../../components/wallet/nft_grid_view.dart'; // Import the NftGridView component
import '../../components/wallet/assets_list_view.dart'; // Import the AssetsListView component
import '../../components/wallet/tab_button.dart'; // Import the TabButton component

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
  final RxInt _selectedIndex = 0.obs; // Changed to RxInt

  final List<Widget> _screens = [
    WalletPageContent(address: '0x0effsadad79756'), // Create a separate widget for WalletPage content
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
  final String address; // Add address parameter

  WalletPageContent({required this.address}); // Update constructor

  final RxInt activeTab = 0.obs; // Define activeTab within WalletPageContent

  @override
  Widget build(BuildContext context) {
    final PriceController priceController = Get.find();
    final ChainController chainController = Get.find();

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
              BalanceContainer(totalValue: totalValue, address: address), // Use the new BalanceContainer with address
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
                            TabButton(index: 0, title: 'Tokens', activeTab: activeTab), // Use TabButton
                            const SizedBox(width: 40), // Increased spacing between tab buttons
                            TabButton(index: 1, title: 'NFTs', activeTab: activeTab), // Use TabButton
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Obx(() => AnimatedCrossFade(
                      firstChild: priceController.prices.isNotEmpty
                          ? AssetsListView(assets: getAssets()) // Use the AssetsListView component
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
                      secondChild: NftGridView(nfts: getNfts()), // Use the NftGridView component
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
}
