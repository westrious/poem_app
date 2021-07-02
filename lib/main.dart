import 'package:flutter/material.dart';
import 'package:poem_app/home_page.dart';
import 'package:poem_app/network/method.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getString("token") == null) {
    final res = await Method.getToken();
    String token;
    if (res["status"] == "success") {
      token = res["data"];
    } else {
      print("can't get the token!");
      return;
    }
    prefs.setString("token", token);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}
