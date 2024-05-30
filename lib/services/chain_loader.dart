import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:yaml/yaml.dart';
import '../models/chain_model.dart';

Future<List<Chain>> loadChains() async {
  // Load the YAML file from the assets
  final yamlString = await rootBundle.loadString('assets/chain_configs.yaml');

  // Parse the YAML content
  final yamlMap = loadYaml(yamlString);
  final List<Chain> chains = [];

  // Iterate over the chains and create Chain objects
  (yamlMap['chains'] as Map).forEach((key, value) {
    chains.add(Chain.fromYamlMap(value));
  });
  debugPrint("Chains: $chains");
  return chains;
}