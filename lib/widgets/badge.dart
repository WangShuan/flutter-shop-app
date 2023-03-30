import 'package:flutter/material.dart';

class MyBadge extends StatelessWidget {
  final Widget child;
  final String value;
  final Color color;

  const MyBadge({
    Key key,
    @required this.child,
    @required this.value,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color:
                  color != null ? color : Theme.of(context).colorScheme.error,
            ),
            constraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
              ),
            ),
          ),
          right: 8,
          top: 8,
        )
      ],
    );
  }
}
