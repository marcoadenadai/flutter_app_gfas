import 'dart:convert';
import 'dart:io';

import 'package:GFAS/constants.dart';
import 'package:flutter/material.dart';

import 'package:GFAS/constants.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class EntrarOpcao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text('Entrar como:', style: TextStyle( fontSize: 20, color: Colors.grey)),
            AdministradorImage(),
            FlatButton(
                onPressed: () {
                  //Navigator.of(context).pushNamed('/cadastroAdministrador');
                },
                child: Container(
                  color: Colors.lightBlue,
                  child: Center(
                    child: Text('Administrador', style: TextStyle(fontSize: 28)),
                  ),
                  width: HOME_LARGURA_BOTAO,
                  height: HOME_ALTURA_BOTAO,
                )),
            BombeiroImage(),
            FlatButton(
                onPressed: () {
                  //Navigator.of(context).pushNamed('/cadastroBombeiro');
                },
                child: Container(
                  color: Colors.red,
                  child: Center(
                    child: Text('Corpo de Bombeiros', style: TextStyle(fontSize: 28)),
                  ),
                  height: HOME_ALTURA_BOTAO,
                  margin: EdgeInsets.only(top: 10.0, bottom: 20.0),
                  width: HOME_LARGURA_BOTAO,
                )),
          ],
        ),
      ),
    );
  }
}

class AdministradorImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(ADM_IMG, height: 200, width: 150, ),
      ],
    );
  }
}

class BombeiroImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(BOMB_IMG, height: 200, width: 150, ),
      ],
    );
  }
}