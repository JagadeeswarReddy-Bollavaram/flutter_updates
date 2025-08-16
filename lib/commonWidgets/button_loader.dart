import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AppSubmitButtonLoader extends StatefulWidget {
  const AppSubmitButtonLoader({super.key});

  @override
  State<AppSubmitButtonLoader> createState() => _AppSubmitButtonLoaderState();
}

class _AppSubmitButtonLoaderState extends State<AppSubmitButtonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> moveAnimation;
  late Animation<double> first;
  late Animation last;
  bool ball1Turn = true;
  @override
  void initState() {
    animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
      reverseDuration: Duration(milliseconds: 200),
    );
    moveAnimation = Tween<double>(
      begin: 0.0,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.bounceInOut,
      ),
    );
    first = Tween<double>(begin: 0.0, end: -50.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.bounceInOut));

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Reverse the animation to come back to center
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        // Switch turns and restart
        ball1Turn = !ball1Turn;
        animationController.forward();
        // Future.delayed(Duration(milliseconds: 300), () {
        //   animationController.forward();
        // });
      }
    });
    animationController.forward();
    super.initState();
  }

  Widget buildBall({Color color = Colors.black}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: moveAnimation,
        builder: (context, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.translate(
                offset: Offset(ball1Turn ? first.value : 0.0, 0.0),
                child: buildBall(),
              ),
              // const SizedBox(width: 10),
              buildBall(),
              // const SizedBox(width: 10),
              Transform.translate(
                offset: Offset(ball1Turn ? 0.0 : moveAnimation.value, 0.0),
                child: buildBall(),
              ),
            ],
          );
        });
  }
}
