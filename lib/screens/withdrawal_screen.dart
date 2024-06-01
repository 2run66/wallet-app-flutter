import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cryptofont/cryptofont.dart';
import 'package:flutter/services.dart';
import 'package:getx_deneme/screens/withdrawal_confirmation_screen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class WithdrawalScreen extends StatefulWidget {
  final String selectedToken;

  WithdrawalScreen({required this.selectedToken});

  @override
  _WithdrawalScreenState createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  String selectedChain = 'Ethereum';
  late String selectedToken;
  final TextEditingController addressController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final List<String> chains = ['Ethereum', 'Binance Smart Chain', 'Solana', 'Avalanche'];
  final Map<String, List<String>> tokens = {
    'Ethereum': ['ETH', 'USDT', 'DAI'],
    'Binance Smart Chain': ['BNB', 'BUSD', 'CAKE'],
    'Solana': ['SOL', 'USDC', 'USDT'],
    'Avalanche': ['AVAX']
  };
  final Map<String, IconData> chainIcons = {
    'Ethereum': CryptoFontIcons.eth,
    'Binance Smart Chain': CryptoFontIcons.bnb,
    'Solana': CryptoFontIcons.sol,
    'Avalanche': CryptoFontIcons.avax
  };
  final Map<String, IconData> tokenIcons = {
    'ETH': CryptoFontIcons.eth,
    'USDT': CryptoFontIcons.usdt,
    'DAI': CryptoFontIcons.dai,
    'AVAX': CryptoFontIcons.avax,
    'BNB': CryptoFontIcons.bnb,
    'BUSD': CryptoFontIcons.busd,
    'CAKE': CryptoFontIcons.cake,
    'MATIC': CryptoFontIcons.matic,
    'USDC': CryptoFontIcons.usdc,
    'SOL': CryptoFontIcons.sol
  };

  final Map<String, String> tokenAbbreviations = {
    'Ethereum': 'ETH',
    'Avalanche': 'AVAX',
    'Solana': 'SOL',
    'Bnb': 'BNB',
  };

  bool showConfirmation = false;
  String addressWarning = '';

  String _findChainByToken(String token) {
    for (var entry in tokens.entries) {
      if (entry.value.contains(token)) {
        return entry.key;
      }
    }
    return 'Ethereum'; // Default chain
  }

  void _pasteFromClipboard() async {
    ClipboardData? clipboardData = await Clipboard.getData('text/plain');
    if (clipboardData != null && clipboardData.text != null) {
      setState(() {
        addressController.text = clipboardData.text!;
        _validateAddress();
      });
    }
  }

  void _resetAddress() {
    setState(() {
      addressController.text = '';
      addressWarning = '';
    });
  }

  void _setMaxAmount() {
    setState(() {
      amountController.text = 'MAX_AMOUNT'; // Replace with actual logic to fetch max amount.
    });
  }

  void _navigateToConfirmation() {
    if (_isValidAddress(addressController.text) && addressController.text.isNotEmpty && amountController.text.isNotEmpty) {
      setState(() {
        showConfirmation = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid address and amount.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _navigateBack() {
    setState(() {
      showConfirmation = false;
    });
  }

  void _openCameraModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black.withOpacity(0.8),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            Container(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Expanded(
              child: MobileScanner(
                onDetect: (barcode, args) {
                  final String code = barcode.rawValue ?? '';
                  if (_isValidAddress(code)) {
                    setState(() {
                      addressController.text = code;
                      addressWarning = '';
                    });
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Invalid QR code.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isValidAddress(String address) {
    // Example regex for Ethereum address validation
    final regex = RegExp(r'^(0x)?[0-9a-fA-F]{40}$');
    return regex.hasMatch(address);
  }

  void _validateAddress() {
    setState(() {
      if (_isValidAddress(addressController.text)) {
        addressWarning = '';
      } else {
        addressWarning = 'Invalid address format';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    selectedToken = widget.selectedToken;
    selectedChain = _findChainByToken(selectedToken);
    addressController.addListener(_validateAddress);
  }

  @override
  void dispose() {
    addressController.removeListener(_validateAddress);
    addressController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF232323),
              Colors.black,
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            stops: [0.0, 1.0],
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: showConfirmation
                ? WithdrawalConfirmation(
              chain: selectedChain,
              token: selectedToken,
              address: addressController.text,
              amount: amountController.text,
              gasPrice: '50', // Mock gas price
              onCancel: _navigateBack,
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Withdrawal',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Select Chain',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: chains.contains(selectedChain) ? selectedChain : null,
                      dropdownColor: Colors.black,
                      icon: Icon(Icons.arrow_downward, color: Colors.white),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.white),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedChain = newValue!;
                          selectedToken = tokens[selectedChain]!.first;
                        });
                      },
                      items: chains.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: [
                              Icon(chainIcons[value], color: Colors.white),
                              SizedBox(width: 10),
                              Text(value),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Select Token',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: tokens[selectedChain]!.contains(selectedToken) ? selectedToken : null,
                      dropdownColor: Colors.black,
                      icon: Icon(Icons.arrow_downward, color: Colors.white),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.white),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedToken = newValue!;
                        });
                      },
                      items: tokens[selectedChain]!.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: [
                              Icon(tokenIcons[value], color: Colors.white),
                              SizedBox(width: 10),
                              Text(value),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Withdrawal Address',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                if (addressWarning.isNotEmpty)
                  Text(
                    addressWarning,
                    style: TextStyle(color: Colors.redAccent, fontSize: 14),
                  ),
                Container(
                  width: double.infinity,
                  child: TextField(
                    controller: addressController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter withdrawal address',
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          addressController.text.isNotEmpty ? Icons.close : Icons.paste,
                          color: Colors.white,
                        ),
                        onPressed: addressController.text.isNotEmpty ? _resetAddress : _pasteFromClipboard,
                      ),
                      prefixIcon: IconButton(
                        icon: Icon(Icons.qr_code, color: Colors.white),
                        onPressed: () => _openCameraModal(context),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Withdrawal Amount',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  child: TextField(
                    controller: amountController,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter amount',
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: TextButton(
                        onPressed: _setMaxAmount,
                        child: Text(
                          'Max',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (addressController.text.isEmpty || ! _isValidAddress(addressController.text)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please enter a valid withdrawal address'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else if (amountController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please enter an amount'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else {
                        _navigateToConfirmation();
                      }
                    },
                    child: Text('Withdraw'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'Ensure the address is correct. Incorrect addresses may result in loss of funds.',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
