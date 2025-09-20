import 'package:flutter/material.dart';
import '../models/ads.dart';

class AdWidget extends StatefulWidget {
  final Ads ad;
  final bool isPopup; // true for reward/interstitial, false for banner
  final VoidCallback? onCompleted; // callback when reward is finished

  const AdWidget({
    Key? key,
    required this.ad,
    this.isPopup = false,
    this.onCompleted,
  }) : super(key: key);

  @override
  State<AdWidget> createState() => _AdWidgetState();
}

class _AdWidgetState extends State<AdWidget> {
  int _secondsLeft = 5; // countdown for reward ad
  bool _showTimer = false;

  @override
  void initState() {
    super.initState();
    if (widget.isPopup) {
      _startTimer();
    }
  }

  void _startTimer() {
    setState(() => _showTimer = true);
    Future.delayed(const Duration(seconds: 1), _tick);
  }

  void _tick() {
    if (_secondsLeft > 1) {
      setState(() => _secondsLeft -= 1);
      Future.delayed(const Duration(seconds: 1), _tick);
    } else {
      setState(() => _showTimer = false);
      if (widget.onCompleted != null) widget.onCompleted!();
    }
  }

  void _handleClick() {
    // Open ad link
    // You can use url_launcher package
    // launch(widget.ad.link);
    if (!widget.isPopup && widget.onCompleted != null) {
      widget.onCompleted!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleClick,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.network(
            widget.ad.imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: widget.isPopup ? 250 : 100,
          ),
          if (_showTimer)
            Container(
              color: Colors.black54,
              padding: const EdgeInsets.all(8),
              child: Text(
                'Wait $_secondsLeft s',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }
}
