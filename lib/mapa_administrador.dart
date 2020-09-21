import 'package:flutter/material.dart';
import 'package:nominatim_location_picker/nominatim_location_picker.dart';

class MapaAdministrador extends StatefulWidget {
  @override
  _MapaAdministradorState createState() => _MapaAdministradorState();
}

class _MapaAdministradorState extends State<MapaAdministrador> {
  Map _pickedLocation;
  var _pickedLocationText;

  Future getLocationWithNominatim() async {
    Map result = await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return NominatimLocationPicker(
            searchHint: 'Pesquisar',
            awaitingForLocation: "Procurando por sua localização",
          );
        });
    if (result != null) {
      setState(() => _pickedLocation = result);
    } else {
      return;
    }
  }

  RaisedButton localizaButton(Color color, String name) {
    return RaisedButton(
      color: color,
      onPressed: () async {
        await getLocationWithNominatim();
      },
      textColor: Colors.white,
      child: Center(
        child: Text(name),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    );
  }

  RaisedButton menuAdminButton(Color color, String name) {
    return RaisedButton(
      color: color,
      onPressed: () {
        Navigator.of(context).pushNamed('/menuAdministrador');
      },
      textColor: Colors.white,
      child: Center(
        child: Text(name),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    );
  }

  Widget appBar() {
    return AppBar(
      centerTitle: true,
      title: Text('Selecione localização de interesse'),
    );
  }

  Widget body(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: _pickedLocation != null
              ? Center(child: Text("$_pickedLocation"))
              : localizaButton(Colors.blue, 'Cadastrar Localização'),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: _pickedLocationText != null
              ? Center(child: Text("$_pickedLocationText"))
              : menuAdminButton(Colors.green, 'Menu Administrador'),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey, appBar: appBar(), body: body(context));
  }
}
