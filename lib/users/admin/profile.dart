import 'package:flutter/material.dart';

class PerfilAdmin extends StatefulWidget {
  @override
  _PerfilAdminState createState() => _PerfilAdminState();
}

final userIdLabel = Text('App Id: ');
final emailLabel = Text('Email: ');
final firstNameLabel = Text('First Name: ');
final lastNameLabel = Text('Last Name: ');
final settingsIdLabel = Text('SetttingsId: ');

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
  var _nome = "Nome do Usuário";
  var _email = "email@exemplo.com";
  var _senha = "****************";
  var _cpf = "333.333.333-33";
  var _rg = "33.333.333-3";
  var _cep = "13600-000";

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
              profileEntry("Nome:", _nome, () {
                editNome();
              }),
              SizedBox(height: 12.0),
              profileEntry("Email:", _email, () {}),
              SizedBox(height: 12.0),
              profileEntry("Senha:", _senha, () {}),
              SizedBox(height: 12.0),
              profileEntry("Cep:", _cep, () {}),
              SizedBox(height: 12.0),
              profileEntry("Rg:", _rg, () {}),
              SizedBox(height: 12.0),
              profileEntry("Cpf:", _cpf, () {}),
              SizedBox(height: 12.0),
              profileEntry("Terreno Cadastrado:", "Área de Interesse", () {}),
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
                    //todo funcao encerrar sessao
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
  Future editNome() {
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
                  key: null,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: "Alterar Nome:",
                              hintText: "Insira um novo nome"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          child: Text("Confirmar"),
                          onPressed: () {},
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
