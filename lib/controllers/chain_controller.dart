import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chain_model.dart';
import '../services/chain_loader.dart';

class ChainController extends GetxController {
  var selectedChain = Chain(name: 'Ethereum', chainId: 1, network: 'mainnet', rpcUrls: ['https://rpc.ankr.com/eth'], symbol: 'eth').obs;
  var balance = 0.0.obs;
  var chains = <Chain>[].obs;

  @override
  void onInit() async {
    super.onInit();
    chains.value = await loadChains();
    if (chains.isNotEmpty) {
      selectedChain.value = chains.first;
      fetchBalance(selectedChain.value.rpcUrls.first);
    }
  }

  void changeChain(Chain chain, String address) {
    selectedChain.value = chain;
    fetchBalance(address);
  }

  Future<void> fetchBalance(String address) async {
    final rpcUrl = selectedChain.value.rpcUrls.first;
    final response = await http.post(
      Uri.parse(rpcUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'jsonrpc': '2.0',
        'method': 'eth_getBalance',
        'params': ['${address}', 'latest'],
        'id': 1,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final balanceHex = data['result'] as String;
      final balanceInWei = BigInt.parse(balanceHex.substring(2), radix: 16);
      balance.value = balanceInWei / BigInt.from(1e18);
    } else {
      Get.snackbar('Error', 'Failed to fetch balance');
    }
  }
}