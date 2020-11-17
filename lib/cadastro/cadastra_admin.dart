import 'package:flutter/material.dart';
import 'package:GFAS/map/funcs.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:GFAS/map/pos.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

//--------------------------------------------------------------------------
class CadastroObj {
  String nome = '';
  String senha = '';
  String email = '';
  String telefone = '';
  String cpf = '';
  String rg = '';
  String cep = '';
  String token = '';

  CadastroObj(String n, String s, String e, String tel, String cpf, String rg,
      String cep, String tok) {
    nome = n;
    senha = s;
    email = e;
    telefone = tel;
    this.cpf = cpf;
    this.rg = rg;
    this.cep = cep;
    token =  tok;
  }

  void clear() {
    this.nome = '';
    this.senha = '';
    this.email = '';
    this.telefone = '';
    this.cpf = '';
    this.rg = '';
    this.cep = '';
    this.token = '';
  }
}

CadastroObj cadastro;
//VARIAVEL GLOBAL ACESSADA PELO CADASTRA_OPCAO!

class CadastraTerrenoAdmin extends StatefulWidget {
  @override
  _CadastraTerrenoAdminState createState() => _CadastraTerrenoAdminState();
}

class _CadastraTerrenoAdminState extends State<CadastraTerrenoAdmin> {
  Icon _searchIcon = new Icon(Icons.search);
  static String def_title = "Cadastrar Terreno";
  Widget _appBarTitle = new Text(def_title);
  bool _center_title = true;
  bool _selecting = false;
  bool _searching = false;
  List _buskaList = List();
  var points = <LatLng>[];
  LatLng pos = LatLng(-22.8330542, -47.0509806);
  LatLng _centroide;
  double _raio = 0;

  List getJsonPoints(List<LatLng> p) {
    List points = [];
    for (int i = 0; i < p.length; i++) {
      points.add({'latitude': p[i].latitude, 'longitude': p[i].longitude});
    }
    return points;
  }

  //FUNCAO DE CADASTRO
  Future criarAdministrador() async {
    final http.Response response = await http.post(
      'http://ec2-52-67-230-208.sa-east-1.compute.amazonaws.com:8000/gfas-srv-user/administradores',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'nome': cadastro.nome,
        'email': cadastro.email,
        'telefone': cadastro.telefone,
        'cpf': cadastro.cpf,
        'rg': cadastro.rg,
        'cep': cadastro.cep,
        'senha': cadastro.senha,
        'coordenadaCentroide': {
          'latitude': _centroide.latitude,
          'longitude': _centroide.longitude
        },
        'raioCentroide': _raio.toString(),
        'coordenadasArea': getJsonPoints(points),
        'pushToken': cadastro.token,
      }),
    );

    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print('Criado');
      print(getJsonPoints(points));
      return Future.value(true);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      print('ERRO');
      return Future.error("fail");
    }
  }

  //************************************************************************/
  _CadastraTerrenoAdminState() {
    if (Pos().pos != null)
      pos = LatLng(Pos().pos.latitude, Pos().pos.longitude);
    else
      pos = LatLng(-22.8330542, -47.0509806);
  }

  //************************************************************************/
  Widget mapa() {
    return FlutterMap(
      options: MapOptions(
        onTap: (latlng) /*async*/ {
          //print(latlng.toString());
          if (_selecting) {
            setState(() {
              points.add(new LatLng(latlng.latitude, latlng.longitude));
            });
          }
          //print(intersecList(points));
        },
        center: pos,
        zoom: 11.0,
      ),
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

  Widget buska() {
    return Container(
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _buskaList.length,
        itemBuilder: (BuildContext context, int index) {
          return Center(
            child: Card(
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  setState(() {
                    double lat = double.tryParse(_buskaList[index]['lat']);
                    double lng = double.tryParse(_buskaList[index]['lng']);
                    pos = LatLng(lat, lng);
                    this._searchIcon = new Icon(Icons.search);
                    this._appBarTitle = new Text(def_title);
                    this._center_title = true;
                    _searching = false;
                  });
                  print('Card tapped. [' + index.toString() + ']');
                },
                child: Container(
                  //height: 80,
                  color: Colors.blueGrey[15],
                  child: Center(
                      child: Text(_buskaList[index]['description'].toString())),
                ),
              ),
            ),
          );
          //
        },
        //separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }

  Widget principal(BuildContext context) {
    if (!_searching)
      return mapa();
    else
      return buska();
  }

  Widget searchField() {
    return TextField(
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Buscar Endereço..',
        hintStyle: TextStyle(color: Colors.white),
      ),
      onSubmitted: (value) async {
        setState(() {
          _buskaList.clear();
        });
        if (value != "") {
          dynamic busca = await NominatimService().getAddressLatLng(value);
          setState(() {
            _buskaList = busca;
          });
        }
      },
    );
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = searchField();
        this._center_title = false;
        _searching = true;
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text(def_title);
        this._center_title = true;
        _searching = false;
        setState(() {
          _buskaList.clear();
        });
      }
    });
  }

  // ignore: non_constant_identifier_names
  Widget SearchBar(BuildContext context) {
    return AppBar(
      centerTitle: _center_title,
      title: _appBarTitle,
      leading: new IconButton(
        icon: _searchIcon,
        onPressed: _searchPressed,
      ),
    );
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

  // ignore: non_constant_identifier_names
  Widget FloatingButtons(BuildContext context) {
    if (!_searching) {
      if (_selecting) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              backgroundColor: Colors.redAccent,
              child: Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _selecting = false;
                  points.clear();
                });
              },
              heroTag: null,
            ),
            SizedBox(height: 10),
            FloatingActionButton(
              backgroundColor: Colors.blue,
              child: Icon(Icons.check),
              onPressed: () {
                //valida property selection
                if (points[0].latitude != points[points.length - 1].latitude &&
                    points[0].longitude !=
                        points[points.length - 1].longitude) {
                  setState(() {
                    points.add(points[0]);
                  });
                }
                if (!intersecList(points)) {
                  print("Valid Polygon Selected");
                  setState(() {
                    _selecting = false;
                  });
                  //AQUI JA TEMOS O RAIO E O CENTRO DA AREA DE INTERESSE
                  _centroide = getPolygonCentroid(points);
                  _raio = calculatePropertyRadius(
                      getPolygonCentroid(points), points);
                  print("raio(km):" + _raio.toString());
                  print("centro=" + _centroide.toString());
                  //CADASTRA AKI!!!
                  criarAdministrador().then((value) async {
                    print("criarAdministrador()->" + value.toString());
                    if (value == true) {
                      await showAlertDialog(context, "Sucesso!",
                              "Seu cadastro foi criado, estamos redirecionando você para a tela inicial.")
                          .then((value) {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      });
                    }
                  }).catchError((e) {
                    print("criarAdministrador()->" + e.toString());
                    showAlertDialog(context, "Erro no cadastro",
                        "Connection timed out, verifique sua conexão e tente novamente..");
                  });
                  //-----------------------
                } else {
                  setState(() {
                    points.clear();
                    showAlertDialog(context, "Área inválida",
                        "Você selecionou uma área inválida, selecione um poligono fechado.");
                  });
                }
              },
              heroTag: null,
            ),
          ],
        );
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              backgroundColor: Colors.blue,
              child: Icon(Icons.flag),
              onPressed: () {
                setState(() {
                  _selecting = true;
                });
              },
              heroTag: null,
            ),
          ],
        );
      }
    }
    return null;
  }

  //--------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchBar(context),
      body: principal(context),
      floatingActionButton: FloatingButtons(context),
    );
  }
  //--------------------------------------------------------------------------

}
