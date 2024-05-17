import 'package:flutter/material.dart';
import '../styles/style.dart';

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

  @override
  Widget build(BuildContext context) {
    double amount = double.tryParse(asset['amount'].split(' ')[0]) ?? 0.0;
    double value = amount * currentPrice;

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
    );
  }
}
