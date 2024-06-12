import 'package:flutter/material.dart';
import 'nft_item.dart';

class NftGridView extends StatelessWidget {
  final List<Map<String, dynamic>> nfts;

  NftGridView({required this.nfts});

  @override
  Widget build(BuildContext context) {
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
