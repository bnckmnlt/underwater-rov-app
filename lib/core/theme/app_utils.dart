import 'package:flutter/cupertino.dart';

class BoxShadowComponent {
  static BoxShadow? getBoxShadow(String shadow) {
    switch (shadow) {
      case "sm":
        return BoxShadow(
          color: const Color(0x0D000000),
          offset: const Offset(0, 1),
          blurRadius: 2,
        );
      case "md":
        return BoxShadow(
          color: const Color(0x1A000000),
          offset: const Offset(0, 4),
          blurRadius: 6,
          spreadRadius: -1,
        );
      case "lg":
        return BoxShadow(
          color: const Color(0x1A000000),
          offset: const Offset(0, 10),
          blurRadius: 15,
          spreadRadius: -3,
        );
      case "xl":
        return BoxShadow(
          color: const Color(0x1A000000),
          offset: const Offset(0, 20),
          blurRadius: 25,
          spreadRadius: -5,
        );
      case "2xl":
        return BoxShadow(
          color: const Color(0x40000000),
          offset: const Offset(0, 25),
          blurRadius: 50,
          spreadRadius: -12,
        );
      case "inner":
        return BoxShadow(
          color: const Color(0x0D000000),
          offset: const Offset(0, 2),
          blurRadius: 4,
          spreadRadius: 0,
          blurStyle: BlurStyle.inner,
        );
      case "none":
        return null; // No shadow
      default:
        return null; // Default to no shadow if the label isn't recognized
    }
  }
}
