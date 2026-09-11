import 'package:flutter/material.dart';

class PulsingLocationDot extends StatefulWidget {
  const PulsingLocationDot({super.key});

  @override
  State<PulsingLocationDot> createState() => _PulsingLocationDotState();
}

class _PulsingLocationDotState extends State<PulsingLocationDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            //  Expanding pulse circle
            Container(
              width: 40 + (_controller.value * 30),
              height: 40 + (_controller.value * 30),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withValues(alpha:  0.2 * (1 - _controller.value)),
              ),
            ),

            //   center dot
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
              ),
            ),
          ],
        );
      },
    );
  }
}