import 'package:flutter/material.dart';

class SubButtonOverlay extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback onDepositTap;
  final VoidCallback onWithdrawTap;

  SubButtonOverlay({
    required this.onClose,
    required this.onDepositTap,
    required this.onWithdrawTap,
  });

  @override
  _SubButtonOverlayState createState() => _SubButtonOverlayState();
}

class _SubButtonOverlayState extends State<SubButtonOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _leftButtonOffsetAnimation;
  late Animation<Offset> _rightButtonOffsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..forward();

    _leftButtonOffsetAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset(-1, -1.5),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _rightButtonOffsetAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset(1, -1.5),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          GestureDetector(
            onTap: widget.onClose,
            child: Container(
              color: Colors.transparent,
            ),
          ),
          Positioned(
            bottom: 00,
            left: MediaQuery.of(context).size.width / 2 - 30,
            child: SlideTransition(
              position: _leftButtonOffsetAnimation,
              child: FloatingActionButton(
                onPressed: widget.onDepositTap,
                backgroundColor: Colors.pink,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_upward),
                    SizedBox(height: 4),
                    Text('Deposit', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: MediaQuery.of(context).size.width / 2 - 30,
            child: SlideTransition(
              position: _rightButtonOffsetAnimation,
              child: FloatingActionButton(
                onPressed: widget.onWithdrawTap,
                backgroundColor: Colors.pink,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_downward),
                    SizedBox(height: 4),
                    Text('Withdraw', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
