import 'package:flutter/cupertino.dart';
import 'package:utopia_utils/utopia_utils.dart';

class Collapsible extends StatelessWidget {
  final Widget child;
  final Axis axis;
  final bool isExpanded;
  final Duration duration;
  final Curve curve;

  const Collapsible({
    Key? key,
    required this.duration,
    required this.axis,
    this.curve = Curves.decelerate,
    required this.isExpanded,
    required this.child,
  }) : super(key: key);

  const Collapsible.vertical({
    Key? key,
    required this.duration,
    this.curve = Curves.decelerate,
    required this.isExpanded,
    required this.child,
  })  : axis = Axis.vertical,
        super(key: key);

  const Collapsible.horizontal({
    Key? key,
    required this.duration,
    this.curve = Curves.decelerate,
    required this.isExpanded,
    required this.child,
  })  : axis = Axis.horizontal,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedAlign(
      alignment: Alignment.topLeft,
      duration: duration,
      curve: Curves.decelerate,
      heightFactor: (isExpanded ? 1.0 : 0.0).takeIf((_) => axis == Axis.vertical),
      widthFactor: (isExpanded ? 1.0 : 0.0).takeIf((_) => axis == Axis.horizontal),
      child: ClipRect(child: child),
    );
  }
}
