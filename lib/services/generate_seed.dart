import 'dart:typed_data';
import 'package:bip39/bip39.dart' as bip39;
import 'package:pointycastle/export.dart';

String generateMnemonic() {
  return bip39.generateMnemonic();
}

Uint8List generateSeed(String mnemonic) {
  return bip39.mnemonicToSeed(mnemonic);
}

ECPrivateKey generatePrivateKey(Uint8List seed) {
  final keyParams = ECKeyGeneratorParameters(ECCurve_secp256k1());
  final secureRandom = FortunaRandom();
  final seedKey = KeyParameter(seed);
  secureRandom.seed(seedKey);

  final keyGenerator = ECKeyGenerator();
  keyGenerator.init(ParametersWithRandom(keyParams, secureRandom));

  final keyPair = keyGenerator.generateKeyPair();
  final privateKey = keyPair.privateKey as ECPrivateKey;
  return privateKey;
}