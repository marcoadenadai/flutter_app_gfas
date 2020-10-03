import 'package:GFAS/constants.dart';
import 'package:flutter/material.dart';

class EntrarOpcao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text('Entrar como:',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    color: Colors.grey)),
            AdministradorImage(),
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/loginAdministrador');
                },
                child: Container(
                  color: Colors.lightBlue,
                  child: Center(
                    child: Text('Administrador',
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.width * 0.07)),
                  ),
                  height: MediaQuery.of(context).size.height * 0.14,
                  width: MediaQuery.of(context).size.width * 0.75,
                )),
            BombeiroImage(),
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/loginBombeiro');
                },
                child: Container(
                  color: Colors.red,
                  child: Center(
                    child: Text('Corpo de Bombeiros',
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.width * 0.07)),
                  ),
                  margin: EdgeInsets.only(bottom: 20.0),
                  height: MediaQuery.of(context).size.height * 0.14,
                  width: MediaQuery.of(context).size.width * 0.75,
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
        Image.asset(
          ADM_IMG,
          height: MediaQuery.of(context).size.height * 0.30,
          width: MediaQuery.of(context).size.width * 0.30,
        ),
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
        Image.asset(
          BOMB_IMG,
          height: MediaQuery.of(context).size.height * 0.30,
          width: MediaQuery.of(context).size.width * 0.30,
        ),
      ],
    );
  }
}
