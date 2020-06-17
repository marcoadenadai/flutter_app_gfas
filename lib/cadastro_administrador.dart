import 'dart:convert';
import 'dart:io';

import 'package:GFAS/constants.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastroAdministrador extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => CadastroAdministradorState();
}

class CadastroAdministradorState extends State<CadastroAdministrador> {
  final _formKey = GlobalKey<FormState>();

  String nome = '';
  String senha = '';
  String email = '';
  String telefone = '';
  String cpf = '';
  String rg = '';
  String cep = '';
  String nomeArea = '';

  var maskTelefone = new MaskTextInputFormatter(mask: '(##) #####-####', filter: { "#": RegExp(r'[0-9]') });
  var maskCPF = new MaskTextInputFormatter(mask: '###.###.###-##', filter: { "#": RegExp(r'[0-9]') });
  var maskCEP = new MaskTextInputFormatter(mask: '##.###-###', filter: { "#": RegExp(r'[0-9]') });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Cadastro Administrador'),
        ),
        body: Material(
            child: SingleChildScrollView(
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
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
                                return value.isEmpty ? '$POR_FAVOR_DIGITE $O $NOME' : null;
                              },
                              onSaved: (value) {
                                nome = value;
                              },
                            ),
                            TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                  labelText: SENHA,
                                  hintText: '$DIGITE $A $SENHA'
                              ),
                              validator: (value) {
                                return value.isEmpty || value.length < 6 ? VALIDACAO_SENHA : null;
                              },
                              onSaved: (value) {
                                senha = value;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: EMAIL,
                                  hintText: '$DIGITE $O $EMAIL'
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                return EmailValidator.validate(value) ? null : VALIDACAO_EMAIL;
                              },
                              onSaved: (value) {
                                email = value;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: TELEFONE,
                                  hintText: '$DIGITE $O $TELEFONE'
                              ),
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                maskTelefone
                              ],
                              validator: (value) {
                                return value.isEmpty || maskTelefone.getUnmaskedText().length < 10 ? VALIDACAO_TELEFONE : null;
                              },
                              onSaved: (value) {
                                telefone = maskTelefone.getUnmaskedText();
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: CPF,
                                  hintText: '$DIGITE $O $CPF'
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                maskCPF
                              ],
                              validator: (value) {
                                return value.isEmpty || maskCPF.getUnmaskedText().length < 11 ? VALIDACAO_CPF : null;
                              },
                              onSaved: (value) {
                                cpf = maskCPF.getUnmaskedText();
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: RG,
                                  hintText: '$DIGITE $O $RG'
                              ),
                              keyboardType: TextInputType.number,
                              onSaved: (value) {
                                rg = value;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: CEP,
                                  hintText: '$DIGITE $O $CEP'
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                maskCEP
                              ],
                              validator: (value) {
                                return value.isEmpty || maskCEP.getUnmaskedText().length < 8 ? VALIDACAO_CEP : null;
                              },
                              onSaved: (value) {
                                cep = maskCEP.getUnmaskedText();
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: AREA,
                                  hintText: HINT_AREA
                              ),
                              validator: (value) {
                                return value.isEmpty ? '$POR_FAVOR_DIGITE $O $HINT_AREA' : null;
                              },
                              onSaved: (value) {
                                nomeArea = value;
                              },
                            ),
                           RaisedButton(
                             child: Text(SALVAR),
                             onPressed: () {
                               submeter(context);
                             },
                           )
                          ],
                        )
                    )
                )
            )
        )
    );
  }

  void submeter(BuildContext context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      print ('Salvou ${nome}');
      criarAdministrador();

    }
  }

  void criarAdministrador() async {
    final http.Response response = await http.post(
      'http://192.168.1.128:8080/administradores',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nome': nome,
        'senha': senha,
        'email': email,
        'telefone': telefone,
        'cpf': cpf,
        'rg': rg,
        'cep': cep
      }),
    );

    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print ('Criado');
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      print ('ERRO');
      throw Exception('Failed to load album');
    }
  }
}