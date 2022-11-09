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
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: color != null ? color : Theme.of(context).accentColor,
            ),
            constraints: BoxConstraints(minHeight: 16, minWidth: 16),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10),
            ),
          ),
          right: 8,
          top: 8,
        )
      ],
    );
  }
}
