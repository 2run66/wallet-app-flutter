import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

class PriceController extends GetxController {
  var prices = <String, double>{}.obs;
  var tempPrices = <String, double>{};
  var dailyOpenPrices = <String, double>{}.obs; // Store daily open prices here
  var changePercentages = <String, double>{}.obs; // Store change percentages here
  var historicalPrices = <String, List<double>>{}.obs; // Store historical prices for each token
  var isConnected = false.obs;
  late IOWebSocketChannel channel;
  late Timer timer;

  @override
  void onInit() {
    super.onInit();
    fetchDailyOpenPrices();
    fetchHistoricalPrices();
    connectWebSocket();
    startPriceSync();
    startChangePercentageSync();
  }

  void connectWebSocket() {
    final symbols = ['btcusdt', 'ethusdt', 'avaxusdt', 'solusdt', 'bnbusdt'];
    final streams = symbols.map((symbol) => '$symbol@trade').join('/');
    final url = 'wss://stream.binance.com:9443/ws/$streams';

    print('Connecting to $url');

    channel = IOWebSocketChannel.connect(url);

    channel.stream.listen((message) {
      final data = jsonDecode(message);
      final symbol = data['s'].toString().toLowerCase();
      final price = double.parse(data['p']);
      tempPrices[symbol] = price; // Update tempPrices with new data
      updateChangePercentage(symbol, price); // Update change percentage

    }, onDone: () {
      isConnected.value = false;
      print('WebSocket connection done');
      reconnectWebSocket();
    }, onError: (error) {
      isConnected.value = false;
      print('WebSocket connection error: $error');
      reconnectWebSocket();
    });
    isConnected.value = true;
  }

  void reconnectWebSocket() {
    Future.delayed(const Duration(seconds: 5), () {
      connectWebSocket();
    });
  }

  void startPriceSync() {
    print('Starting price synchronization');
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      prices.value = Map<String, double>.from(tempPrices); // Sync tempPrices to prices every 5 seconds
    });
  }

  void startChangePercentageSync() {
    print('Starting change percentage synchronization');
    Timer.periodic(const Duration(seconds: 5), (timer) {
      tempPrices.forEach((symbol, price) {
        updateChangePercentage(symbol, price);
      });
    });
  }

  void updateChangePercentage(String symbol, double currentPrice) {
    if (dailyOpenPrices.containsKey(symbol) && dailyOpenPrices[symbol] != null) {
      double openPrice = dailyOpenPrices[symbol]!;
      double changePercentage = ((currentPrice - openPrice) / openPrice) * 100;
      changePercentages[symbol] = changePercentage;
    }
  }

  void fetchDailyOpenPrices() async {
    final symbols = ['btcusdt', 'ethusdt', 'avaxusdt', 'solusdt', 'bnbusdt'];
    for (var symbol in symbols) {
      final url = Uri.parse('https://api.binance.com/api/v3/ticker/24hr?symbol=${symbol.toUpperCase()}');
      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          if (data.containsKey('openPrice') && data['openPrice'] != null) {
            final openPrice = double.parse(data['openPrice']);
            dailyOpenPrices[symbol] = openPrice;
          } else {
            print('Open price for $symbol is null or not present');
          }
        } else {
          print('Failed to fetch daily open price for $symbol. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching daily open price for $symbol: $e');
      }
    }
  }

  void fetchHistoricalPrices() async {
    final symbols = ['btcusdt', 'ethusdt', 'avaxusdt', 'solusdt', 'bnbusdt'];
    for (var symbol in symbols) {
      final url = Uri.parse('https://api.binance.com/api/v3/klines?symbol=${symbol.toUpperCase()}&interval=1d&limit=30');
      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body) as List;
          List<double> prices = data.map((item) => double.parse(item[4].toString())).toList(); // Closing prices
          historicalPrices[symbol] = prices;
        } else {
          print('Failed to fetch historical prices for $symbol. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching historical prices for $symbol: $e');
      }
    }
  }

  @override
  void onClose() {
    channel.sink.close();
    timer.cancel();
    super.onClose();
  }
}
