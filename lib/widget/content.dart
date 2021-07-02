import 'package:flutter/material.dart';
import 'package:poem_app/widget/poem.dart';
import 'package:poem_app/widget/sentence.dart';
import 'package:slimy_card/slimy_card.dart';

class Content extends Dialog {
  final Color color;
  final Poem poem;
  final BuildContext context;
  const Content(
    this.context, {
    Key key,
    @required this.color,
    @required this.poem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: false,
      stream: slimyCard.stream,
      builder: ((BuildContext context, AsyncSnapshot snapshot) {
        return ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(height: 50),
            SlimyCard(
              topCardHeight: 400,
              bottomCardHeight: 270,
              color: color,
              topCardWidget: topCardWidget(),
              bottomCardWidget: bottomCardWidget(),
            ),
          ],
        );
      }),
    );
  }

  Widget topCardWidget() {
    List sentencesList = [];
    // 处理诗句，一个逗号一行
    for (int i = 0; i < poem.content.length; i++) {
      int startIndex = 0;
      int endIndex = 0;
      for (int j = 0; j < poem.content[i].length; j++) {
        if (isPunctuation(poem.content[i][j])) {
          endIndex = j + 1;
          sentencesList.add(poem.content[i].substring(startIndex, endIndex));
          startIndex = endIndex;
        }
      }
    }
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            poem.title,
            style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: 23,
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            poem.dynasty + " · " + poem.author,
            style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          ...List.generate(
              sentencesList.length,
              (index) => Text(
                    sentencesList[index],
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  )),
        ],
      ),
    );
  }

  Widget bottomCardWidget() {
    List translate = poem.translate ?? ["抱歉，暂无翻译～"];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ...List.generate(
              translate.length,
              (index) => Text(
                translate[index],
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                '关闭',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
