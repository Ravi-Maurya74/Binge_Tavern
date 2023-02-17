import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:flutter/material.dart';

class ExpandWidget extends StatefulWidget {
  const ExpandWidget({super.key, required this.first, required this.second,required this.scrollController});
  final Widget first;
  final Widget second;
  final ScrollController scrollController;

  @override
  State<ExpandWidget> createState() => _ExpandWidgetState();
}

class _ExpandWidgetState extends State<ExpandWidget> {
  bool toggle = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          toggle = !toggle;
        });
      },
      child: AnimatedSizeAndFade(
        child: toggle ? widget.first : widget.second,
      ),
    );
  }
}
