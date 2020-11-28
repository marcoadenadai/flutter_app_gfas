import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../constants.dart';
import '../sessao.dart';

class PerfilAdmin extends StatefulWidget {
  Sessao S;
  PerfilAdmin({Key key, @required this.S}) : super(key: key);
  @override
  _PerfilAdminState createState() => _PerfilAdminState(S);
}

Widget profileEntry(String label, String value, Function f) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(label),
      Row(
        children: [
          Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
          Container(
            height: 30.0,
            child: IconButton(
              icon: Icon(Icons.edit, color: Colors.blue[300]),
              onPressed: f,
              iconSize: 16,
              alignment: Alignment.topCenter,
            ),
          ),
        ],
      ),
    ],
  );
}

class _PerfilAdminState extends State<PerfilAdmin> {
  Sessao S;
  _PerfilAdminState(Sessao S) {
    this.S = S;
  }

  Widget profilePage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 12.0),
              profileEntry("Nome:", S.nome, () {
                editNome();
              }),
              SizedBox(height: 12.0),
              profileEntry("Email:", S.email, () {
                editEmail();
              }),
              SizedBox(height: 12.0),
              profileEntry("Senha:", "************", () {
                editSenha();
              }),
              SizedBox(height: 12.0),
              profileEntry("Cep:", S.cep, () {
                editCep();
              }),
              SizedBox(height: 12.0),
              profileEntry("Rg:", S.rg, () {
                editRg();
              }),
              SizedBox(height: 12.0),
              profileEntry("Cpf:", S.cpf, () {
                editCpf();
              }),
              /*SizedBox(height: 12.0),
              profileEntry("Terreno Cadastrado:", "Área de Interesse", () {}),*/
              SizedBox(height: 32.0),
              Padding(
                padding: EdgeInsets.only(bottom: 3),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  onPressed: () {
                    //todo funcao excluir conta
                  },
                  padding: EdgeInsets.all(12),
                  color: Colors.grey[700],
                  child: Text('Excluir Conta',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  onPressed: () {
                    print(S.points);
                    //todo funcao encerrar sessao
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  padding: EdgeInsets.all(12),
                  color: Theme.of(context).primaryColor,
                  child: Text('Encerrar Sessão',
                      style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //formularios para edicao do cadastro: -------------------------------------
  var maskCPF = new MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});
  var maskCEP = new MaskTextInputFormatter(
      mask: '##.###-###', filter: {"#": RegExp(r'[0-9]')});
  var maskRG = new MaskTextInputFormatter(
      mask: '##.###.###-L',
      filter: {"#": RegExp(r"[0-9]"), "L": RegExp(r"[0-9]|[a-z]|[A-Z]")});

  Future editNome() {
    String editString = "";
    final _formKey = GlobalKey<FormState>();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.close),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: "Alterar Nome:",
                              hintText: "Insira um novo nome"),
                          inputFormatters: [],
                          validator: (value) {
                            return value.isEmpty
                                ? '$POR_FAVOR_DIGITE $O $NOME'
                                : null;
                          },
                          onSaved: (value) {
                            editString = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          child: Text("Confirmar"),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              Sessao tmp = Sessao().copy(S);
                              tmp.nome = editString;
                              S.admin_update(tmp).then((value) {
                                setState(() {
                                  S.nome = editString;
                                });
                                Navigator.of(context).pop();
                              }).catchError((e) {
                                showAlertDialog(
                                    context,
                                    "ERRO",
                                    "Não foi possível comunicar com o " +
                                        "servidor, verifique sua conexão e tente novamente.");
                              });
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future editEmail() {
    String editString = "";
    final _formKey = GlobalKey<FormState>();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.close),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: "Alterar e-mail:",
                              hintText: "Insira um novo e-mail"),
                          inputFormatters: [],
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            return EmailValidator.validate(value)
                                ? null
                                : VALIDACAO_EMAIL;
                          },
                          onSaved: (value) {
                            editString = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          child: Text("Confirmar"),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              Sessao tmp = Sessao().copy(S);
                              tmp.email = editString;
                              S.admin_update(tmp).then((value) {
                                setState(() {
                                  S.email = editString;
                                });

                                Navigator.of(context).pop();
                              }).catchError((e) {
                                showAlertDialog(
                                    context,
                                    "ERRO",
                                    "Não foi possível comunicar com o " +
                                        "servidor, verifique sua conexão e tente novamente.");
                              });
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future editSenha() {
    String editString = "";
    final _formKey = GlobalKey<FormState>();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.close),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: "Alterar Senha:",
                              hintText: "Insira uma nova senha"),
                          inputFormatters: [],
                          validator: (value) {
                            return value.isEmpty || value.length < 6
                                ? VALIDACAO_SENHA
                                : null;
                          },
                          onSaved: (value) {
                            editString = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          child: Text("Confirmar"),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              Sessao tmp = Sessao().copy(S);
                              tmp.senha = editString;
                              S.admin_update(tmp).then((value) {
                                showAlertDialog(context, "Sucesso",
                                    "A senha foi alterada com sucesso!");
                              }).catchError((e) {
                                showAlertDialog(
                                    context,
                                    "ERRO",
                                    "Não foi possível comunicar com o " +
                                        "servidor, verifique sua conexão e tente novamente.");
                              });
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future editCep() {
    String editString = "";
    final _formKey = GlobalKey<FormState>();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.close),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: "Alterar CEP:",
                              hintText: "Insira um novo CEP"),
                          inputFormatters: [maskCEP],
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            return value.isEmpty ||
                                    maskCEP.getUnmaskedText().length < 8
                                ? VALIDACAO_CEP
                                : null;
                          },
                          onSaved: (value) {
                            editString = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          child: Text("Confirmar"),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              Sessao tmp = Sessao().copy(S);
                              tmp.cep = maskCEP.getUnmaskedText();
                              S.admin_update(tmp).then((value) {
                                setState(() {
                                  S.cep = maskCEP.getUnmaskedText();
                                });

                                Navigator.of(context).pop();
                              }).catchError((e) {
                                showAlertDialog(
                                    context,
                                    "ERRO",
                                    "Não foi possível comunicar com o " +
                                        "servidor, verifique sua conexão e tente novamente.");
                              });
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future editRg() {
    String editString = "";
    final _formKey = GlobalKey<FormState>();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.close),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: "Alterar RG:",
                              hintText: "Insira um novo RG"),
                          inputFormatters: [maskRG],
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            return value.isEmpty ||
                                    maskRG.getUnmaskedText().length < 8
                                ? VALIDACAO_RG
                                : null;
                          },
                          onSaved: (value) {
                            editString = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          child: Text("Confirmar"),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              Sessao tmp = Sessao().copy(S);
                              tmp.rg = editString; //maskRG.getUnmaskedText();
                              S.admin_update(tmp).then((value) {
                                setState(() {
                                  S.rg = editString;
                                });

                                Navigator.of(context).pop();
                              }).catchError((e) {
                                showAlertDialog(
                                    context,
                                    "ERRO",
                                    "Não foi possível comunicar com o " +
                                        "servidor, verifique sua conexão e tente novamente.");
                              });
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future editCpf() {
    String editString = "";
    final _formKey = GlobalKey<FormState>();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.close),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: "Alterar CPF:",
                              hintText: "Insira um novo CPF"),
                          inputFormatters: [maskCPF],
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            return value.isEmpty ||
                                    maskCPF.getUnmaskedText().length < 11
                                ? VALIDACAO_CPF
                                : null;
                          },
                          onSaved: (value) {
                            editString = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          child: Text("Confirmar"),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              Sessao tmp = Sessao().copy(S);
                              tmp.cpf = maskCPF.getUnmaskedText();
                              S.admin_update(tmp).then((value) {
                                setState(() {
                                  S.cpf = maskCPF.getUnmaskedText();
                                });

                                Navigator.of(context).pop();
                              }).catchError((e) {
                                showAlertDialog(
                                    context,
                                    "ERRO",
                                    "Não foi possível comunicar com o " +
                                        "servidor, verifique sua conexão e tente novamente.");
                              });
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
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

  //--------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu Perfil"),
      ),
      body: profilePage(context),
    );
  }
}
