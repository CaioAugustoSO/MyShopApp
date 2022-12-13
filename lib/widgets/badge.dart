// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  //

  final Widget child;

  final String value;

  final Color color;

  const Badge(
      {super.key,
      required this.value,
      required this.color,
      required this.child});
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              // ignore: prefer_if_null_operators
              color: color != null
                  ? color
                  : Theme.of(context).colorScheme.secondary,
            ),
            constraints: const BoxConstraints(minHeight: 16, minWidth: 16),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10),
            ),
          ),
        )
      ],
    );
  }
}
