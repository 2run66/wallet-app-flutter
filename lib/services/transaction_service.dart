import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3dart/crypto.dart';

class TransactionService {
  final String rpcUrl;
  final Web3Client _client;

  TransactionService({required this.rpcUrl}) : _client = Web3Client(rpcUrl, http.Client());

  Future<String> sendTransaction({
    required String fromAddress,
    required String toAddress,
    required String privateKey,
    required BigInt value,
    int? gasLimit,
    BigInt? gasPrice,
  }) async {
    try {
      final credentials = EthPrivateKey.fromHex(privateKey);
      final from = EthereumAddress.fromHex(fromAddress);
      final to = EthereumAddress.fromHex(toAddress);

      // Get the nonce
      final nonce = await _client.getTransactionCount(from, atBlock: const BlockNum.pending());

      // Create the transaction
      final transaction = Transaction(
        from: from,
        to: to,
        value: EtherAmount.inWei(value),
        gasPrice: gasPrice != null ? EtherAmount.inWei(gasPrice) : null,
        maxGas: gasLimit,
        nonce: nonce,
      );

      // Sign and send the transaction
      final txHash = await _client.sendTransaction(credentials, transaction, chainId: 1);

      return txHash;
    } catch (e) {
      throw Exception('Failed to send transaction: $e');
    }
  }

  Future<Map<String, dynamic>> getTransactionReceipt(String txHash) async {
    try {
      final receipt = await _client.getTransactionReceipt(txHash);
      if (receipt != null) {
        return {
          'transactionHash': receipt.transactionHash,
          'transactionIndex': receipt.transactionIndex,
          'blockHash': receipt.blockHash,
          'blockNumber': receipt.blockNumber,
          'cumulativeGasUsed': receipt.cumulativeGasUsed,
          'gasUsed': receipt.gasUsed,
          'contractAddress': receipt.contractAddress,
          'status': receipt.status,
        };
      } else {
        throw Exception('Transaction not found');
      }
    } catch (e) {
      throw Exception('Failed to fetch transaction receipt: $e');
    }
  }

  Future<String> generatePrivateKeyFromSeed(String seed) async {
    // Implement your logic to generate private key from seed
    // This is a placeholder function
    return 'your_private_key';
  }

  Future<String> getMnemonic() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('mnemonic').toString() ?? '';
  }
}