import 'package:GFAS/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class LoginAdministrador extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginAdministradorState();
}

class LoginAdministradorState extends State<LoginAdministrador> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
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
                                Navigator.of(context)
                                    .pushNamed('/menuAdministrador');
                              },
                            ),
                            BotaoCadastroGFAS(),
                          ],
                        ))))));
  }
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