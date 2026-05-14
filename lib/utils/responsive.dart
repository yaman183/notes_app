import 'package:flutter/material.dart';

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;

  const ResponsiveWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: width > 700 ? 650 : double.infinity,
        ),
        child: child,
      ),
    );
  }
}