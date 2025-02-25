import 'package:flutter/material.dart';
import 'dart:math' show pi;

class FlipCard extends StatefulWidget {
  final Widget front;
  final Widget back;
  final VoidCallback onFlip;
  final bool isFront;

  const FlipCard({
    Key? key,
    required this.front,
    required this.back,
    required this.onFlip,
    this.isFront = true,
  }) : super(key: key);

  @override
  _FlipCardState createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _frontAnimation;
  late Animation<double> _backAnimation;
  bool isFront;

  @override
  void initState() {
    super.initState();
    isFront = widget.isFront;
    
    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _frontAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: pi / 2)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50.0,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(pi / 2),
        weight: 50.0,
      ),
    ]).animate(_controller);

    _backAnimation = TweenSequence([
      TweenSequenceItem(
        tween: ConstantTween<double>(pi / 2),
        weight: 50.0,
      ),
      TweenSequenceItem(
        tween: Tween(begin: pi / 2, end: pi)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50.0,
      ),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFront != oldWidget.isFront) {
      if (widget.isFront) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isFront = !isFront;
          if (isFront) {
            _controller.reverse();
          } else {
            _controller.forward();
          }
          widget.onFlip();
        });
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              // 앞면
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0012) // 원근감 추가
                  ..rotateY(_frontAnimation.value),
                child: _frontAnimation.value <= pi / 2
                    ? widget.front
                    : Container(),
              ),
              // 뒷면
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0012) // 원근감 추가
                  ..rotateY(_backAnimation.value),
                child: _backAnimation.value >= pi / 2
                    ? widget.back
                    : Container(),
              ),
            ],
          );
        },
      ),
    );
  }
}
