import 'dart:math';

import 'package:flutter/material.dart';
import 'package:poem_app/network/method.dart';
import 'package:poem_app/widget/box.dart';
import 'package:poem_app/widget/content.dart';
import 'package:poem_app/widget/poem.dart';
import 'package:poem_app/widget/sentence.dart';
import 'package:poem_app/widget/tag.dart';
import 'package:poem_app/widget/tips.dart';
import 'package:scratcher/scratcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List _charsList = [];
  List _correctSentence = [];

  Color _color = Colors.blue[100];
  String token;
  int _maxLength = 0;
  Poem poem = Poem();
  String _sentenceTraslate = "";
  bool _next = false;

  final _scratchKey = GlobalKey<ScratcherState>();

  @override
  void initState() {
    super.initState();
    _initToken();
  }

  _initToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token") ?? "";
    _nextPoem();
  }

  _initChars() {
    print(poem.sentence);
    _charsList.clear();
    _correctSentence.clear();
    _maxLength = 0;
    _charsList.add([]);
    _correctSentence.add([]);
    int index = 0;
    for (int i = 0; i < poem.sentence.length - 1; i++) {
      final char = poem.sentence[i];
      if (!isPunctuation(char)) {
        _charsList[index].add(Char(i, char));
        _correctSentence[index].add(Char(i, char));
      } else {
        _maxLength = max(_maxLength, _charsList[index].length);
        _charsList.add([]);
        _correctSentence.add([]);
        _charsList[index].shuffle();
        index++;
      }
    }
    _charsList[_charsList.length - 1].shuffle();
    _maxLength = max(_maxLength, _charsList[_charsList.length - 1].length);
  }

  _getPoem() async {
    final res = await Method.getSentence(token);
    if (res["status"] == "success") {
      final data = res["data"];
      final origin = data["origin"];
      poem
        ..sentence = data["content"]
        ..title = origin["title"]
        ..dynasty = origin["dynasty"]
        ..author = origin["author"]
        ..content = origin["content"]
        ..translate = origin["translate"]
        ..matchTags = data["matchTags"];
    }
    if (poem.sentence.length > 16) {
      int lastIndex = 0;
      for (int i = 0; i < poem.sentence.length; i++) {
        if (poem.sentence[i] == "，") {
          lastIndex = i;
        }
      }
      poem.sentence = poem.sentence.substring(0, lastIndex);
    }
  }

  _initSentenceTranslate() {
    _sentenceTraslate = "";
    if (poem.translate == null) return;
    int index = poem.content.indexOf(poem.sentence);
    if (index == -1) {
      for (int i = 0; i < poem.content.length; i++) {
        if (poem.content[i].contains(poem.sentence)) {
          index = i;
          break;
        }
      }
    }
    _sentenceTraslate = poem.translate[index];
  }

  _nextPoem() async {
    await _getPoem();
    setState(() {
      _next = false;
      _color = Colors.primaries[Random().nextInt(Colors.primaries.length)][100];
      _initChars();
      _initSentenceTranslate();
      _scratchKey.currentState.reset();
    });
  }

  Future<void> _showAllPoem(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Content(
            context,
            color: _color,
            poem: poem,
          );
        });
  }

  _checkWinCondition() {
    for (int i = 0; i < _charsList.length; i++) {
      for (int j = 0; j < _charsList[i].length; j++) {
        if (_charsList[i][j].content != _correctSentence[i][j].content) {
          return;
        }
      }
    }
    _showAllPoem(context).then((_) => setState(() {
          _next = true;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 100),
          Text(
            poem.title,
            style: TextStyle(fontSize: 32),
          ),
          Text(
            poem.dynasty + " · " + poem.author,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),
          Tag(matchTags: poem.matchTags),
          SizedBox(height: 20),
          Container(
            height: 3 * Box.height,
            child: Stack(
              children: List.generate(
                _charsList.length,
                (i) => Senetence(
                  chars: _charsList[i],
                  color: _color,
                  index: i,
                  left: (MediaQuery.of(context).size.width -
                          _maxLength * Box.width) /
                      2,
                  checkWinCondition: _checkWinCondition,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Tips(
            color: _color,
            translate: _sentenceTraslate,
            scratchKey: _scratchKey,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _next ? _color : Color(0xFF888888),
        foregroundColor: Colors.white,
        onPressed: _next ? _nextPoem : null,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
