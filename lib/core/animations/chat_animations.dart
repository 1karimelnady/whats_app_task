import 'package:flutter/material.dart';

class ChatAnimations {
  static Widget messageBubble({
    required AnimationController animationController,
    required int index,
    required Widget child,
  }) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animationController,
        curve: Interval(
          0.1 * index,
          0.3 * index + 0.7,
          curve: Curves.easeInOut,
        ),
      ),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: animationController,
                curve: Interval(
                  0.1 * index,
                  0.3 * index + 0.7,
                  curve: Curves.easeOut,
                ),
              ),
            ),
        child: child,
      ),
    );
  }

  static Widget sendMessageAnimation({
    required AnimationController animationController,
    required Widget child,
  }) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: animationController, curve: Curves.elasticOut),
      ),
      child: FadeTransition(opacity: animationController, child: child),
    );
  }
}
