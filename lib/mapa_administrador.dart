import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MapaAdministrador extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => MapaAdministradorState();
}

class MapaAdministradorState extends State<MapaAdministrador> {
@override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RaisedButton(
            onPressed: _launchURL,
            child: Text('Ver Mapa'),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/menuAdministrador');
            },
            child: Text('Menu Administrador'),
          ),
        ],
      ),
    );

  /*Scaffold(
      body: Center(
        children: [
          RaisedButton(
            onPressed: _launchURL,
            child: Text('Ver Mapa'),
          ),
          RaisedButton(
            onPressed: _launchURL,
            child: Text('Menu Administrador'),
          ),
        ]
      ),
    );*/
  }
_launchURL() async {
  const url = 'https://www.google.com.br/maps';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
}




