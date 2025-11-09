import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A widget that wraps a child and conditionally displays a shield icon
/// in the top-right corner if [showShield] is true.
class ShieldDateWrapper extends StatelessWidget {
  const ShieldDateWrapper({
    super.key,
    required this.child,
    required this.showShield,
  });

  /// The child widget to wrap
  final Widget child;

  /// Whether to show the shield icon
  final bool showShield;

  @override
  Widget build(BuildContext context) {
    if (!showShield) {
      return child;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset(
          'lib/src/ui/icons/shield_icon_date_wrapper.svg',
          package: 'clean_calendar',
          width: 30,
          height: 30,
        ),
        DefaultTextStyle(
          style: const TextStyle(color: Colors.black),
          child: child,
        ),
      ],
    );
  }
}
