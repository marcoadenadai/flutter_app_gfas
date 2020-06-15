import 'package:GFAS/cadastro_administrador.dart';
import 'package:GFAS/constants.dart';
import 'package:flutter/material.dart';

void main() => runApp(GFASApp());

class GFASApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GFAS',
        home: Scaffold(
            body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const SizedBox(
                      height: 5,
                    ),
                    HomeLogo(),
                    HomeButtons()
                  ],
              )
            )
        ),
      routes: <String, WidgetBuilder> {
          '/cadastroAdministrador': (BuildContext context) => CadastroAdministrador()
      },
    );
  }
}

class HomeLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(HOME_LOGO, height: 300, width: 250, ),
      ],
    );
  }
}

class HomeButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        FlatButton(
            onPressed: () {},
            child: Container(
              color: Colors.lightBlue,
              child: Center(
                child: Text(ENTRAR, style: TextStyle(fontSize: 28)),
              ),
              width: HOME_LARGURA_BOTAO,
              height: HOME_ALTURA_BOTAO,
            )),
        const SizedBox(
          height: 10,
        ),
        FlatButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/cadastroAdministrador');
            },
            child: Container(
              color: Colors.red,
              child: Center(
                child: Text(CADASTRAR, style: TextStyle(fontSize: 28)),
              ),
              width: HOME_LARGURA_BOTAO,
              height: HOME_ALTURA_BOTAO,
            )),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
