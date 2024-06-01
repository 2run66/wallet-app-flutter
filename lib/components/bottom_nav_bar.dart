import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_deneme/screens/settings_screen.dart';
import 'package:getx_deneme/components/sub_button.dart';
import 'package:getx_deneme/screens/deposit_screen.dart';
import 'package:getx_deneme/screens/withdrawal_screen.dart';

class BottomNavBar extends StatefulWidget {
  final RxInt selectedIndex;
  final Function(int) onItemTapped;

  BottomNavBar({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  OverlayEntry? _overlayEntry;
  bool _isOverlayVisible = false;
  bool _isMiddleButtonSelected = false;

  BoxDecoration bottomNavBarDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFF1E1E1E),
          Color(0xFF3C3C3C),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, 1.0],
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.5),
          spreadRadius: 10,
          blurRadius: 10,
          offset: Offset(0, 3),
        ),
      ],
    );
  }

  BoxDecoration middleButtonDecoration() {
    return BoxDecoration(
      color: Colors.pink,
      shape: BoxShape.circle,
      boxShadow: _isMiddleButtonSelected
          ? [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          spreadRadius: 4,
          blurRadius: 8,
        ),
      ]
          : [],
    );
  }

  BoxDecoration normalButtonDecoration(int index) {
    return BoxDecoration(
      boxShadow: [],
    );
  }

  void _showSubButtons() {
    setState(() {
      _isMiddleButtonSelected = !_isMiddleButtonSelected;
    });
    if (_isOverlayVisible) {
      _overlayEntry?.remove();
      _isOverlayVisible = false;
    } else {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context)?.insert(_overlayEntry!);
      _isOverlayVisible = true;
    }
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => SubButtonOverlay(
        onClose: _showSubButtons,
        onDepositTap: () {
          _showSubButtons(); // Close sub buttons
          _showDepositScreen(context); // Show deposit screen
        },
        onWithdrawTap: () {
          _showSubButtons(); // Close sub buttons
          _showWithdrawScreen(context, 'ETH'); // Show withdrawal screen with ETH token
        },
      ),
    );
  }

  void _showSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SettingsScreen();
      },
    );
  }

  void _showDepositScreen(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DepositScreen();
      },
    );
  }

  void _showWithdrawScreen(BuildContext context, String selectedToken) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return WithdrawalScreen(
          selectedToken: 'ETH',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      decoration: bottomNavBarDecoration(),
      child: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Container(
              decoration: normalButtonDecoration(0),
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Icon(Icons.account_balance_wallet),
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: _showSubButtons,
              child: Container(
                decoration: middleButtonDecoration(),
                child: Transform.rotate(
                  angle: 1.5708, // Rotate 90 degrees (in radians)
                  child: Container(
                    padding: EdgeInsets.all(6.0),
                    child: Center(
                      child: Icon(Icons.swap_horiz, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () => _showSettings(context),
              child: Container(
                decoration: normalButtonDecoration(2),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Icon(Icons.settings),
                ),
              ),
            ),
            label: '',
          ),
        ],
        currentIndex: widget.selectedIndex.value,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.transparent,
        onTap: (index) {
          // Prevent the middle button from being selected
          if (index != 1) {
            widget.onItemTapped(index);
            setState(() {
              _isMiddleButtonSelected = false;
            });
          } else {
            _showSubButtons();
          }
        },
      ),
    ));
  }
}
