import 'package:flutter/material.dart';
import 'package:poem_app/widget/box.dart';

bool isPunctuation(String char) {
  return char == "，" ||
      char == "。" ||
      char == "！" ||
      char == "？" ||
      char == "：";
}

class Senetence extends StatefulWidget {
  final List chars;
  final Color color;
  final int index;
  final double left;
  final Function checkWinCondition;
  Senetence({
    Key key,
    @required this.chars,
    @required this.color,
    @required this.index,
    @required this.left,
    @required this.checkWinCondition,
  }) : super(key: key);

  @override
  _SenetenceState createState() => _SenetenceState();
}

class _SenetenceState extends State<Senetence> {
  int _slot;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: (event) {
        final x = event.position.dx - widget.left;
        if (x > (_slot + 1) * Box.width) {
          if (_slot == widget.chars.length - 1) return;
          setState(() {
            final c = widget.chars[_slot];
            widget.chars[_slot] = widget.chars[_slot + 1];
            widget.chars[_slot + 1] = c;
            _slot++;
          });
        } else if (x < _slot * Box.width) {
          if (_slot == 0) return;
          setState(() {
            final c = widget.chars[_slot];
            widget.chars[_slot] = widget.chars[_slot - 1];
            widget.chars[_slot - 1] = c;
            _slot--;
          });
        }
      },
      child: Stack(
        children: List.generate(widget.chars.length, (i) {
          return Box(
            key: ValueKey(widget.chars[i]),
            char: widget.chars[i],
            x: i * Box.width + widget.left,
            y: widget.index * Box.height,
            color: widget.color,
            onDrag: (char) {
              final index = widget.chars.indexOf(char);
              _slot = index;
            },
            onEnd: widget.checkWinCondition,
          );
        }),
      ),
    );
  }
}
