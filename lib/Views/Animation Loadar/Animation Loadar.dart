import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnimatedCircleAnimation extends StatefulWidget {
  @override
  _AnimatedCircleAnimationState createState() =>
      _AnimatedCircleAnimationState();
}

class _AnimatedCircleAnimationState extends State<AnimatedCircleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _circleAnimation;
  late Animation<double> _circleBlAnimation;
  late Animation<double> _circleTrAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
      });

    _circleAnimation = Tween<double>(begin: 0.0, end: 360.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.linear),
      ),
    );

    _circleBlAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeInOut),
      ),
    );

    _circleTrAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeInOut),
      ),
    );

    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated Circle Animation'),
      ),
      body: Center(
        child: Stack(
          children: [
            Transform.rotate(
              angle: _circleAnimation.value * 0.0174533,
              // Convert degrees to radians
              child: SvgPicture.asset(
                'assets/svg/Hash.svg',
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Transform.rotate(
                angle: _circleBlAnimation.value * pi,
                child: Transform.translate(
                  offset: const Offset(-10, 10),
                  child: SvgPicture.asset(
                    'assets/svg/Circle_1.svg',
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Transform.rotate(
                angle: _circleTrAnimation.value * pi,
                child: Transform.translate(
                  offset: const Offset(10, -10),
                  child: SvgPicture.asset(
                    'assets/svg/Circle_2.svg',
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
