import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class HomeAdmin extends StatefulWidget {
  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  LatLng _pos = LatLng(-22.8330542, -47.0509806);
  var points = <LatLng>[];
  MapController _mapController = MapController();
  int _notificationCounter = 0;
  //--------------------------------------------
  _HomeAdminState() {}
  //--------------------------------------------
  Widget mapa(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        //onTap: (latlng) {},
        center: _pos,
        zoom: 11.0,
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
              // todo: !!! pegar centroide da propriedade
              //_mapController.move(
              //      LatLng(value.latitude, value.longitude), 13.0);
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
                _mapController.move(
                    LatLng(value.latitude, value.longitude), 13.0);
              });
            }).catchError((e) {
              setState(() {
                _mapController.move(LatLng(-22.8330542, -47.0509806), 13.0);
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
      title: Text("Olá, Usuário"),
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
            //editar cadastro admin
          ),
          _createDrawerItem(
            icon: Icons.email,
            text: 'Sugestões',
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
