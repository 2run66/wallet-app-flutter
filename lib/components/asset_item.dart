import 'package:flutter/material.dart';
import '../styles/style.dart';
import '../screens/token_detail_screen.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

class AssetItem extends StatelessWidget {
  final Map<String, dynamic> asset;
  final String Function(double) formatPrice;
  final double currentPrice;
  final double changePercentage;
  final String Function(double) formatChangePercentage;

  const AssetItem({
    required this.asset,
    required this.formatPrice,
    required this.currentPrice,
    required this.changePercentage,
    required this.formatChangePercentage,
    Key? key,
  }) : super(key: key);

  void _navigateToTokenDetailScreen(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: TokenDetailScreen(
          tokenName: asset['name'],
          tokenIcon: asset['icon'],
          tokenPrice: currentPrice,
          dailyChange: changePercentage,
          userAmount: double.tryParse(asset['amount'].split(' ')[0]) ?? 0.0,
          graphData: [
            FlSpot(0, 1),
            FlSpot(1, 1.5),
            FlSpot(2, 1.4),
            FlSpot(3, 3.4),
            FlSpot(4, 2),
            FlSpot(5, 2.2),
            FlSpot(6, 1.8),
          ], // Pass the actual graph data here
          transactionHistory: [
            {'date': '2024-06-01', 'amount': '0.5 ETH'},
            {'date': '2024-05-30', 'amount': '0.3 ETH'},
          ], // Pass the actual transaction history here
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double amount = double.tryParse(asset['amount'].split(' ')[0]) ?? 0.0;
    double value = amount * currentPrice;

    return GestureDetector(
      onTap: () => _navigateToTokenDetailScreen(context),
      child: Padding(
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
                      Row(
                        children: [
                          Text(
                            '\$${formatPrice(currentPrice)}',
                            style: AppStyles.greyTextStyle(14),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            formatChangePercentage(changePercentage),
                            style: TextStyle(
                              color: changePercentage >= 0 ? Colors.greenAccent : Colors.redAccent,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 10,
                                  color: changePercentage >= 0 ? Colors.greenAccent : Colors.redAccent,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                          ),
                        ],
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
                    style: AppStyles.greyTextStyle(14),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
