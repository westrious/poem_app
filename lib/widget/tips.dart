import 'package:flutter/material.dart';
import 'package:scratcher/widgets.dart';

class Tips extends StatelessWidget {
  final Color color;
  final String translate;
  final GlobalKey scratchKey;
  const Tips({
    Key key,
    @required this.color,
    @required this.translate,
    @required this.scratchKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 10.0, //设置阴影
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                "翻译",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(height: 20),
              Scratcher(
                key: scratchKey,
                color: Colors.grey,
                threshold: 30,
                brushSize: 40,
                child: Container(
                  color: color,
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.all(8.0),
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: SingleChildScrollView(
                    child: Text(
                      translate == "" ? "抱歉，暂无翻译～" : translate,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
