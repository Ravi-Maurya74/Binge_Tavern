import 'package:flutter/material.dart';

class FadeOnScroll extends StatefulWidget {
  final ScrollController scrollController;
  final Widget child;

  const FadeOnScroll({
    super.key,
    required this.scrollController,
    required this.child,
  });

  @override
  _FadeOnScrollState createState() => _FadeOnScrollState();
}

class _FadeOnScrollState extends State<FadeOnScroll> {
  double _offset = 0;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.scrollController.hasClients) {
        _offset = widget.scrollController.offset;
        widget.scrollController.addListener(_setOffset);
      }
    });
  }

  @override
  dispose() {
    widget.scrollController.removeListener(_setOffset);
    super.dispose();
  }

  void _setOffset() {
    setState(() {
      _offset = widget.scrollController.offset;
    });
  }

  double _calculateOpacity() {
    double oldValue = (_offset / 90).clamp(0, 1).toDouble();
    if (oldValue < 0.39) return 0.0;
    double oldMin = 0.39;
    double oldMax = 0.67;
    double newMin = 0.0;
    double newMax = 1.0;
    double oldRange = oldMax - oldMin;
    double newRange = newMax - newMin;
    double newValue = (((oldValue - oldMin) * newRange) / oldRange) + newMin;
    return newValue.clamp(0.0, 1.0).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _calculateOpacity(),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Color.fromRGBO(24, 25, 32, 1),
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
          ),
          Positioned(
            top: 8,
            left: 5,
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
