import 'package:bip32/bip32.dart' as bip32;
import 'dart:convert';
import 'dart:typed_data';

import 'package:getx_deneme/services/generate_seed.dart';

// Assuming Ethereum uses m/44'/60'/0'/0 derivation path
bip32.BIP32 deriveKey(String mnemonic) {
  var seed = generateSeed(mnemonic);
  var root = bip32.BIP32.fromSeed(seed);
  var child = root.derivePath("m/44'/60'/0'/0/0");
  return child;
}