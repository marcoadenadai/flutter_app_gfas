import 'package:GFAS/constants.dart';
import 'package:flutter/material.dart';

void main() => runApp(GFASApp());

class GFASApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'GFAS',
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: Center(
                child: Column(
          children: <Widget>[
            const SizedBox(height: 90),
            Image.asset(WELCOME_LOGO, height: 300, width: 250),
            const SizedBox(height: 50),
            HomeButtons()
          ],
        ))));
  }
}

class HomeButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FlatButton(
            onPressed: () {},
            child: Container(
              color: Colors.lightBlue,
              child: Center(
                child: Text(ENTRAR, style: TextStyle(fontSize: 28)),
              ),
              width: 300,
              height: 100,
            )),
        const SizedBox(
          height: 10,
        ),
        FlatButton(
            onPressed: () {},
            child: Container(
              color: Colors.red,
              child: Center(
                child: Text(CADASTRAR, style: TextStyle(fontSize: 28)),
              ),
              width: 300,
              height: 100,
            ))
      ],
    );
  }
}
