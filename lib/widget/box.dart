import 'package:flutter/material.dart';

class Char {
  final int id;
  final String content;
  Char(this.id, this.content);
}

class Box extends StatelessWidget {
  static const width = 50.0;
  static const height = 50.0;
  static const margin = 2.0;
  final Char char;
  final double x, y;
  final Color color;
  final Function(Char) onDrag;
  final Function() onEnd;

  const Box({
    @required Key key,
    @required this.char,
    @required this.x,
    @required this.y,
    @required this.color,
    @required this.onDrag,
    @required this.onEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final container = Container(
      width: width - 2 * margin,
      height: height - 2 * margin,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
          child: Text(
        char.content,
        style: TextStyle(
          decoration: TextDecoration.none,
          fontSize: 30,
          color: Colors.black,
          fontWeight: FontWeight.normal,
        ),
      )),
    );
    return AnimatedPositioned(
      top: y,
      left: x,
      duration: Duration(milliseconds: 100),
      child: Draggable(
        child: container,
        feedback: container,
        childWhenDragging: Visibility(
          visible: false,
          child: container,
        ),
        onDragStarted: () => onDrag(char),
        onDragEnd: (_) => onEnd(),
      ),
    );
  }
}
