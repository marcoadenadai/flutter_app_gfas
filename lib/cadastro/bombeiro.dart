import 'dart:convert';

import 'package:GFAS/constants.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:GFAS/map/pos.dart';
import 'package:GFAS/map/cadastra_bombeiro.dart';

class CadastroBombeiro extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CadastroBombeiroState();
}

class CadastroBombeiroState extends State<CadastroBombeiro> {
  CadastroBombeiroState() {
    cadastro = new CadastroObj('', '', '', '', '', '', '');
  }
  final _formKey = GlobalKey<FormState>();

  var maskTelefone = new MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
  var maskCEP = new MaskTextInputFormatter(
      mask: '##.###-###', filter: {"#": RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Cadastro Corpo de Bombeiros'),
        ),
        body: Material(
            child: SingleChildScrollView(
                child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.1),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: NOME,
                                hintText: '$DIGITE $O $NOME',
                              ),
                              validator: (value) {
                                return value.isEmpty
                                    ? '$POR_FAVOR_DIGITE $O $NOME'
                                    : null;
                              },
                              onSaved: (value) {
                                cadastro.nome = value;
                              },
                            ),
                            TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                  labelText: SENHA,
                                  hintText: '$DIGITE $A $SENHA'),
                              validator: (value) {
                                return value.isEmpty || value.length < 6
                                    ? VALIDACAO_SENHA
                                    : null;
                              },
                              onSaved: (value) {
                                cadastro.senha = value;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: EMAIL,
                                  hintText: '$DIGITE $O $EMAIL'),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                return EmailValidator.validate(value)
                                    ? null
                                    : VALIDACAO_EMAIL;
                              },
                              onSaved: (value) {
                                cadastro.email = value;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: TELEFONE,
                                  hintText: '$DIGITE $O $TELEFONE'),
                              keyboardType: TextInputType.phone,
                              inputFormatters: [maskTelefone],
                              validator: (value) {
                                return value.isEmpty ||
                                        maskTelefone.getUnmaskedText().length <
                                            10
                                    ? VALIDACAO_TELEFONE
                                    : null;
                              },
                              onSaved: (value) {
                                cadastro.telefone =
                                    maskTelefone.getUnmaskedText();
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: CEP, hintText: '$DIGITE $O $CEP'),
                              keyboardType: TextInputType.number,
                              inputFormatters: [maskCEP],
                              validator: (value) {
                                return value.isEmpty ||
                                        maskCEP.getUnmaskedText().length < 8
                                    ? VALIDACAO_CEP
                                    : null;
                              },
                              onSaved: (value) {
                                cadastro.cep = maskCEP.getUnmaskedText();
                              },
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.1),
                            RaisedButton(
                              child: Text("Continuar"),
                              onPressed: () {
                                submeter(context);
                              },
                            )
                          ],
                        ))))));
  }

  Future<void> submeter(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      //print('Salvou $cadastro.nome');
      await Pos().init();
      Navigator.of(context).pushNamed('/cadastraTerrenoBombeiro');
      //criarAdministrador();
    }
  }
}
