import 'dart:io';

import 'package:GFAS/constants.dart';
import 'package:GFAS/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../users/admin/home.dart';
import '../users/sessao.dart';

class LoginAdministrador extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginAdministradorState();
}

class LoginAdministradorState extends State<LoginAdministrador> {
  final _formKey = GlobalKey<FormState>();

  //String email = '';
  String senha = '';
  String telefone = '';

  var maskTelefone = new MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Acesso Administrador'),
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
                            AdministradorImage(),
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
                                telefone = maskTelefone.getUnmaskedText();
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
                                senha = value;
                              },
                            ),
                            RaisedButton(
                              child: Text("Entrar"),
                              onPressed: () {
                                //submeter(context);
                                //Navigator.of(context).pushNamed('/homeAdmin');
                                _formKey.currentState.save();
                                login(context, telefone, senha);
                              },
                            ),
                            BotaoCadastroGFAS(),
                          ],
                        ))))));
  }

  Future<void> login(BuildContext context, String tel, String pass) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Sessao().login(tel, pass).then((value) async {
        print("id=" + value);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeAdmin(
                id_login: value,
              ),
            ));
      }).catchError((e) {
        print(e);
        if (e is SocketException) {
          showAlertDialog(context, "Falha no Login",
              "Não foi possível conectar ao servidor, verifique sua conexão e tente novamente mais tarde.");
        } else {
          showAlertDialog(context, "Falha no Login",
              e.toString() + "Telefone e/ou Senha incorretos.");
        }
      });
    }
  }
}

Future<String> showAlertDialog(
    BuildContext context, String titulo, String msg) async {
  String returnVal = 'fail';
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context, 'success');
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(titulo),
    content: Text(msg),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  returnVal = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
  return returnVal;
}

class AdministradorImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          ADM_IMG,
          height: MediaQuery.of(context).size.height * 0.30,
          width: MediaQuery.of(context).size.width * 0.75,
        ),
      ],
    );
  }
}

class BotaoCadastroGFAS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FlatButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/cadastroAdministrador');
        },
        child: Text('Cadastrar-se no GFAS',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.05,
              color: Colors.blue,
              decoration: TextDecoration.underline,
            )),
      ),
    );
  }
}
