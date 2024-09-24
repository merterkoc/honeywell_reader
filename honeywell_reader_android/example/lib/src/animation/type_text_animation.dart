import 'package:flutter/material.dart';

class TypingTextAnimation extends StatefulWidget {
  const TypingTextAnimation({required this.text, super.key});

  final String text;

  @override
  TypingTextAnimationState createState() => TypingTextAnimationState();
}

class TypingTextAnimationState extends State<TypingTextAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation =
        IntTween(begin: 0, end: widget.text.length).animate(_controller)
          ..addListener(() {
            setState(() {});
          });

    _controller.repeat(); // Animasyonu sürekli tekrar et
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text.substring(0, _animation.value),
    );
  }
}
