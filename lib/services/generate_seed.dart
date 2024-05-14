import 'dart:typed_data';

import 'package:bip39/bip39.dart' as bip39;

String generateMnemonic() {
  return bip39.generateMnemonic();
}

Uint8List generateSeed(String mnemonic) {
  return bip39.mnemonicToSeed(mnemonic);
}