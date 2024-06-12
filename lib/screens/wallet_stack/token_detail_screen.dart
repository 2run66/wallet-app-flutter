import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import '../../controllers/price_controller.dart';
import 'withdrawal_screen.dart';
import 'deposit_screen.dart';
import 'package:getx_deneme/screens/wallet_stack/transaction_history_screen.dart';
import '../../styles/style.dart';

class TokenDetailScreen extends StatelessWidget {
  final String tokenName;
  final IconData tokenIcon;
  final double tokenPrice;
  final double dailyChange;
  final double userAmount;
  final List<FlSpot> graphData;
  final List<Map<String, String>> transactionHistory;

  TokenDetailScreen({
    required this.tokenName,
    required this.tokenIcon,
    required this.tokenPrice,
    required this.dailyChange,
    required this.userAmount,
    required this.graphData,
    required this.transactionHistory,
  });

  final Map<String, String> tokenAbbreviations = {
    'Ethereum': 'ETH',
    'Avalanche': 'AVAX',
    'Solana': 'SOL',
    'Bnb': 'BNB'
  };

  @override
  Widget build(BuildContext context) {
    final PriceController priceController = Get.find<PriceController>();

    String tokenAbbreviation = tokenAbbreviations[tokenName] ?? tokenName.toUpperCase();
    List<FlSpot> historicalGraphData = priceController.historicalPrices[tokenAbbreviation.toLowerCase() + 'usdt']
        ?.asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
        .toList() ??
        [];

    double firstDayPrice = historicalGraphData.isNotEmpty ? historicalGraphData.first.y : 0.0;
    double lastDayPrice = historicalGraphData.isNotEmpty ? historicalGraphData.last.y : 0.0;
    bool isPriceHigher = lastDayPrice >= firstDayPrice;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF232323),
                Colors.black,
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: [0.0, 1.0],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Obx(() {
              String symbol = tokenAbbreviation.toLowerCase() + 'usdt';
              double currentPrice = priceController.prices[symbol] ?? tokenPrice;
              double currentChange = priceController.changePercentages[symbol] ?? dailyChange;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(tokenIcon, color: Colors.white, size: 40),
                          SizedBox(width: 10),
                          Text(
                            tokenName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\$${currentPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '${currentChange.toStringAsFixed(2)}%',
                                style: TextStyle(
                                  color: currentChange >= 0 ? Colors.greenAccent : Colors.redAccent,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 20,
                                      color: currentChange >= 0 ? Colors.greenAccent : Colors.redAccent,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        '$userAmount $tokenAbbreviation',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 200,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LineChart(
                        LineChartData(
                          lineBarsData: [
                            LineChartBarData(
                              spots: historicalGraphData,
                              isCurved: true,
                              color: isPriceHigher ? Colors.green : Colors.pink,
                              barWidth: 3,
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: [
                                    (isPriceHigher ? Colors.green : Colors.pink).withOpacity(0.8),
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              dotData: FlDotData(show: false),
                            ),
                          ],
                          titlesData: FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(show: false),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return DepositScreen();
                              },
                            );
                          },
                          icon: Icon(Icons.arrow_downward, color: Colors.white),
                          label: Text('Deposit'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.transparent,
                            side: BorderSide(color: Colors.white),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return WithdrawalScreen(selectedToken: tokenAbbreviation);
                              },
                            );
                          },
                          icon: Icon(Icons.arrow_upward, color: Colors.white),
                          label: Text('Withdraw'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.transparent,
                            side: BorderSide(color: Colors.white),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Transaction History',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: transactionHistory.isNotEmpty
                        ? ListView.builder(
                      itemCount: transactionHistory.length,
                      itemBuilder: (context, index) {
                        final transaction = transactionHistory[index];
                        return GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                return TransactionDetailScreen(transaction: transaction);
                              },
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.all(10),
                            decoration: AppStyles.assetContainerDecoration(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(tokenIcon, color: Colors.white, size: 24),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          transaction['date']!,
                                          style: AppStyles.whiteTextStyle(16, FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  transaction['amount']!,
                                  style: AppStyles.whiteTextStyle(16),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                        : Center(
                      child: Text(
                        'No transactions found',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
