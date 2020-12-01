import 'package:GFAS/constants.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:GFAS/map/pos.dart';
import 'package:GFAS/cadastro/cadastra_admin.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';

import 'cadastra_admin.dart';

class CadastroAdministrador extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CadastroAdministradorState();
}

class CadastroAdministradorState extends State<CadastroAdministrador> {
  CadastroAdministradorState() {
    cadastro = new CadastroObj('', '', '', '', '', '', '', '');
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _formKey = GlobalKey<FormState>();

  var maskTelefone = new MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
  var maskCPF = new MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});
  var maskCEP = new MaskTextInputFormatter(
      mask: '##.###-###', filter: {"#": RegExp(r'[0-9]')});
  var maskRG = new MaskTextInputFormatter(
      mask: '##.###.###-L',
      filter: {"#": RegExp(r"[0-9]"), "L": RegExp(r"[0-9]|[a-z]|[A-Z]")});

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print("O TOKEN do USER " + token);
      cadastro.token = token;
      print("O Cadastro Token " + cadastro.token);
    });
    _firebaseMessaging.configure(
        onLaunch: (Map<String, dynamic> msg) async {
          print('onLaunch');
        },
        onResume: (Map<String, dynamic> msg) async {
          print('onResumeee' + msg['data']['latitude']);
        },
        onMessage: (Map<String, dynamic> msg) async {
          print('onMessageee');
        },
        onBackgroundMessage: (Map<String, dynamic> msg) async {
          print('onBackgroundMessage' + msg['data']['latitude']);
        },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Cadastro Administrador'),
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
                                  labelText: CPF, hintText: '$DIGITE $O $CPF'),
                              keyboardType: TextInputType.number,
                              inputFormatters: [maskCPF],
                              validator: (value) {
                                return value.isEmpty ||
                                        maskCPF.getUnmaskedText().length < 11
                                    ? VALIDACAO_CPF
                                    : null;
                              },
                              onSaved: (value) {
                                cadastro.cpf = maskCPF.getUnmaskedText();
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: RG, hintText: '$DIGITE $O $RG'),
                              keyboardType: TextInputType.text,
                              inputFormatters: [maskRG],
                              onSaved: (value) {
                                cadastro.rg = value;
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

      Navigator.of(context).pushNamed('/cadastraTerrenoAdmin');
      //criarAdministrador();
    }
  }
}
