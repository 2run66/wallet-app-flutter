import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';

class PriceController extends GetxController {
  var prices = {}.obs;
  var isConnected = false.obs;
  late IOWebSocketChannel channel;
  Timer? _timer;
  Map<String, double> _bufferedPrices = {};

  @override
  void onInit() {
    super.onInit();
    connectWebSocket();

    // Start a periodic timer to refresh the prices every 3 seconds
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      refreshPrices();
    });
  }

  void connectWebSocket() {
    final symbols = ['btcusdt', 'ethusdt', 'avaxusdt', 'solusdt', 'bnbusdt'];
    final streams = symbols.map((symbol) => '$symbol@trade').join('/');
    final url = 'wss://stream.binance.com:9443/ws/$streams';

    channel = IOWebSocketChannel.connect(url);

    channel.stream.listen((message) {
      final data = jsonDecode(message);
      final symbol = data['s'].toLowerCase();
      final price = double.parse(data['p']);
      _bufferedPrices[symbol] = price; // Buffer the price
    }, onDone: () {
      isConnected.value = false;
      reconnectWebSocket();
    }, onError: (error) {
      isConnected.value = false;
      reconnectWebSocket();
    });

    isConnected.value = true;
  }

  void refreshPrices() {
    if (_bufferedPrices.isNotEmpty) {
      prices.assignAll(_bufferedPrices); // Update the prices
      _bufferedPrices.clear(); // Clear the buffer
    }
  }

  void reconnectWebSocket() {
    Future.delayed(Duration(seconds: 5), () {
      connectWebSocket();
    });
  }

  @override
  void onClose() {
    channel.sink.close();
    _timer?.cancel();
    super.onClose();
  }
}
