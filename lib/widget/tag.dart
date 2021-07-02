import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  final matchTags;
  const Tag({Key key, this.matchTags}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
            matchTags == null ? 0 : matchTags.length,
            (index) => Container(
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    border: Border.all(width: 1, color: Colors.green),
                  ),
                  child: Text(
                    matchTags[index],
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                )),
      ),
    );
  }
}
