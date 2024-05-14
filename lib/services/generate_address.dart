import 'dart:typed_data';

import 'package:pointycastle/export.dart';

String publicKeyToAddress(Uint8List publicKey) {
  var digest = Digest("Keccak/256").process(publicKey.sublist(1)); // Remove prefix
  return '0x' + digest.sublist(digest.length - 20).map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
}