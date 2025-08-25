import 'package:flutter/material.dart';

class StoryAnimations {
  static Route createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  static Widget storyProgressAnimation(AnimationController controller) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return LinearProgressIndicator(
          value: controller.value,
          backgroundColor: Colors.grey[600],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
        );
      },
    );
  }
}
