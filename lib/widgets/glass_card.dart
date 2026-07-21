import 'package:flutter/material.dart';
import '../utils/theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double width;
  final double borderRadius;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(32),
    this.width = 400,
    this.borderRadius = 28,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width,
        padding: padding,
        decoration: BoxDecoration(
          color: StaffelTheme.card,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: StaffelTheme.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 60,
              offset: const Offset(0, -20),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
