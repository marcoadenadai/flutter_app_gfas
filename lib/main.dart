import 'package:GFAS/cadastro_opcao.dart';
import 'package:GFAS/entrar_opcao.dart';
import 'package:GFAS/cadastro_administrador.dart';
import 'package:GFAS/cadastro_bombeiro.dart';
import 'package:GFAS/menu_administrador.dart';
import 'package:GFAS/login_administrador.dart';
import 'package:GFAS/login_bombeiro.dart';
import 'package:GFAS/mapa_administrador.dart';
import 'package:GFAS/faq.dart';
import 'package:GFAS/constants.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

void main() => runApp(GFASApp());

class GFASApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],

        // Define the default font family.
        fontFamily: 'Arial',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
        headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
        ),
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
          '/cadastroAdministrador': (BuildContext context) => CadastroAdministrador(),
          '/mapaAdministrador': (BuildContext context) => MapaAdministrador(),
          '/menuAdministrador': (BuildContext context) => MenuAdministrador(),
          '/loginAdministrador': (BuildContext context) => LoginAdministrador(),
          '/loginBombeiro': (BuildContext context) => LoginBombeiro(),
          '/cadastroBombeiro': (BuildContext context) => CadastroBombeiro(),
          '/cadastroOpcao': (BuildContext context) => CadastroOpcao(),
          '/entrarOpcao': (BuildContext context) => EntrarOpcao(),
          '/faq': (BuildContext context) => FAQ()
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
        Image.asset(HOME_LOGO, height: 300, width: 250 ),
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
            onPressed: () {
              Navigator.of(context).pushNamed('/entrarOpcao');
            },
            child: Container(
              color: Colors.lightBlue,
              child: Center(
                child: Text(ENTRAR, style: TextStyle(fontSize: 28)),
              ),
              width: HOME_LARGURA_BOTAO,
              height: HOME_ALTURA_BOTAO,
            )),
        FlatButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/cadastroOpcao');
            },
            child: Container(
              color: Colors.red,
              child: Center(
                child: Text(CADASTRAR, style: TextStyle(fontSize: 28)),
              ),
              height: HOME_ALTURA_BOTAO,
              margin: EdgeInsets.only(top: 10.0, bottom: 20.0),
              width: HOME_LARGURA_BOTAO,
            )),
      ],
    );
  }
}
