import 'package:flutter/material.dart';

class CircleSocialButton extends StatelessWidget {
  const CircleSocialButton({super.key, required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 14,
              offset: const Offset(0, 6),
              color: Colors.black.withOpacity(0.08),
            )
          ],
          border: Border.all(color: Colors.black.withOpacity(0.06)),
        ),
        child: Center(child: child),
      ),
    );
  }
}
