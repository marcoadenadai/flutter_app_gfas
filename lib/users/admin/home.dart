import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:GFAS/users/sessao.dart';

import 'profile.dart';

class HomeAdmin extends StatefulWidget {
  String id_login;
  HomeAdmin({Key key, this.id_login}) : super(key: key);
  @override
  _HomeAdminState createState() => _HomeAdminState(id_login);
}

class _HomeAdminState extends State<HomeAdmin> {
  Sessao S = new Sessao();
  LatLng _pos = LatLng(-22.8330542, -47.0509806);
  var points = <LatLng>[];
  LatLng centroide;
  MapController _mapController = MapController();
  int _notificationCounter = 0;
  String _id;
  String _displayName = "Usuário";
  //--------------------------------------------
  _HomeAdminState(String id) {
    this._id = id;
  }

  @override
  void initState() {
    S.admin_get(_id).then((value) {
      setState(() {
        points = S.points;
        centroide = S.centroide;
        _displayName = S.nome;
        _displayName =
            "${_displayName[0].toUpperCase()}${_displayName.substring(1)}";
      });
    });
    super.initState();
  }

  //--------------------------------------------
  Widget mapa(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        //onTap: (latlng) {},
        center: _pos,
        zoom: 13.0,
      ),
      mapController: _mapController,
      layers: [
        TileLayerOptions(
            urlTemplate:
                "https://api.mapbox.com/styles/v1/marcoadenadai/ckfhcxv7x044f1aqjb8ubnlz6/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibWFyY29hZGVuYWRhaSIsImEiOiJja2ZoY2xtbG4wdDMxMnRvNXB5ZjBhampvIn0.wM51AmYXjM9H_XsCj751dw",
            additionalOptions: {
              'acessToken':
                  'pk.eyJ1IjoibWFyY29hZGVuYWRhaSIsImEiOiJja2ZoY2xtbG4wdDMxMnRvNXB5ZjBhampvIn0.wM51AmYXjM9H_XsCj751dw',
              'id': 'mapbox.satellite',
            }),
        new PolylineLayerOptions(polylines: [
          new Polyline(
            points: points,
            strokeWidth: 5.0,
            color: Colors.pink,
          )
        ]),
      ],
    );
  }

  Widget floatingbutton(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          backgroundColor: Colors.blue,
          child: Icon(Icons.home),
          onPressed: () {
            setState(() {
              _notificationCounter++;
              _mapController.move(centroide, _mapController.zoom);
            });
          },
          heroTag: null,
        ),
        SizedBox(height: 13),
        FloatingActionButton(
          backgroundColor: Colors.blue,
          child: Icon(Icons.gps_fixed),
          onPressed: () async {
            await getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
                .then((value) {
              setState(() {
                _mapController.move(LatLng(value.latitude, value.longitude),
                    _mapController.zoom);
              });
            }).catchError((e) {
              setState(() {
                _mapController.move(
                    LatLng(-22.8330542, -47.0509806), _mapController.zoom);
              });
            });
          },
          heroTag: null,
        ),
      ],
    );
  }

  Widget topbar(BuildContext context) {
    return AppBar(
      title: Text("Olá, " + _displayName),
      actions: <Widget>[
        new Stack(
          children: <Widget>[
            new IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {
                  setState(() {
                    _notificationCounter = 0;
                  });
                  showNotificationDialog();
                }),
            _notificationCounter != 0
                ? new Positioned(
                    right: 11,
                    top: 11,
                    child: new Container(
                      padding: EdgeInsets.all(2),
                      decoration: new BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        '$_notificationCounter',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : new Container()
          ],
        ),
      ],
    );
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(
            icon,
            color: Colors.white,
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text, style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  Widget menu_home(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          SizedBox(height: 20),
          _createDrawerItem(
            icon: Icons.phone,
            text: 'Ligar para Corpo de Bombeiros',
            onTap: () {
              launch("tel://193");
            },
          ),
          _createDrawerItem(
            icon: Icons.person_outline,
            text: 'Meu perfil',
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PerfilAdmin(
                      S: S,
                    ),
                  ));
              //Navigator.of(context).pushNamed('/perfilAdmin');
            },
            //editar cadastro admin
          ),
          _createDrawerItem(
            icon: Icons.email,
            text: 'Sugestões',
            onTap: () async {
              final Email email = Email(
                body: '',
                subject: 'Sugestão GFAS',
                recipients: ['sugestoes@gfas.com'],
                isHTML: false,
              );

              await FlutterEmailSender.send(email)
                  .then((value) => null)
                  .catchError((e) {
                showAlertDialog(
                    context,
                    "Ops",
                    "Ocorreu um erro ao encontrar um aplicativo" +
                        " de emails no seu sistema, instale o app" +
                        " do seu provedor de emails para acessar essa funcionalidade.");
              });
            },
          ),
          _createDrawerItem(
            icon: Icons.help,
            text: 'F.A.Q.',
            onTap: () {
              Navigator.of(context).pushNamed('/faq');
            },
          ),
          _createDrawerItem(
            icon: Icons.exit_to_app,
            text: 'Encerrar Sessão',
            onTap: () {
              //todo quando tiver sessao mesmo encerrala
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
    );
  }

  Future showNotificationDialog() {
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
                /*Form(
                  key: null,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          child: Text("Submitß"),
                          onPressed: () {},
                        ),
                      )
                    ],
                  ),
                ),*/
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

  //BUILD!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topbar(context),
      body: mapa(context),
      floatingActionButton: floatingbutton(context),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.blueAccent,
        ),
        child: menu_home(context),
      ),
    );
  }
}
