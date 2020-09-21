import 'dart:convert';
import 'dart:io';

import 'package:GFAS/constants.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuAdministrador extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BotaoX(),
              BotaoChamarBombeiro(),
              BotaoSugestao(),
              BotaoMeuPerfil(),
              BotaoFAQ(),
            ],
        ),
    );
  }
}

class BotaoX extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/menuAdministrador');
        },
        child: Align(
          alignment: Alignment.topRight,
          child: Container(
            color: Colors.black26,
            width: BOTAO_X_LARGURA,
            height: BOTAO_X_ALTURA,
            child: Center(
              child: Text('X', style: TextStyle(fontSize: 28)),
            ),
          ),
        )
        );
  }
}

class BotaoChamarBombeiro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: () {
          launch("tel://193");
          //Navigator.of(context).pushNamed('/menuAdministrador');
        },
        child: Container(
          color: Colors.red,
          margin: const EdgeInsets.all(10.0),
          child: Center(
            child: Text('Chamar Bombeiros', style: TextStyle(fontSize: 28, color: Colors.white)),
          ),
          width: MENU_BOTAO_LARGURA,
          height: MENU_BOTAO_ALTURA,
        ),
    );
  }
}

class BotaoSugestao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        //Navigator.of(context).pushNamed('/menuAdministrador');
      },
      child: Container(
        color: Colors.black26,
        margin: const EdgeInsets.all(10.0),
        child: Center(
          child: Text('Sugestao', style: TextStyle(fontSize: 28, color: Colors.white)),
        ),
        width: MENU_BOTAO_LARGURA,
        height: MENU_BOTAO_ALTURA,
      ),
    );
  }
}

class BotaoMeuPerfil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        //Navigator.of(context).pushNamed('/menuAdministrador');
      },
      child: Container(
        color: Colors.black26,
        margin: const EdgeInsets.all(10.0),
        child: Center(
          child: Text('Meu Perfil', style: TextStyle(fontSize: 28, color: Colors.white)),
        ),
        width: MENU_BOTAO_LARGURA,
        height: MENU_BOTAO_ALTURA,
      ),
    );
  }
}

class BotaoFAQ extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/faq');
      },
      child: Container(
        color: Colors.black26,
        margin: const EdgeInsets.all(10.0),
        child: Center(
          child: Text('FAQ', style: TextStyle(fontSize: 28, color: Colors.white)),
        ),
        width: MENU_BOTAO_LARGURA,
        height: MENU_BOTAO_ALTURA,
      ),
    );
  }
}



