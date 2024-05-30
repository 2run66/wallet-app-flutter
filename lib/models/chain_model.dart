class Chain {
  final String name;
  final int chainId;
  final String network;
  final List<String> rpcUrls;
  final String symbol;

  Chain({required this.name, required this.chainId, required this.network, required this.rpcUrls, required this.symbol});

  factory Chain.fromYamlMap(Map yamlMap) {
    return Chain(
      name: yamlMap['name'],
      chainId: yamlMap['chainId'],
      network: yamlMap['network'],
      rpcUrls: List<String>.from(yamlMap['rpcUrls']),
      symbol: yamlMap['symbol'],
    );
  }

  @override
  String toString() {
    return 'Chain{name: $name, chainId: $chainId, network: $network, rpcUrls: $rpcUrls, symbol: $symbol}';
  }
}