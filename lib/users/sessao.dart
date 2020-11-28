import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong/latlong.dart';

class Sessao {
  //variaveis
  String id;
  bool admin;
  String nome;
  String email;
  String cep;
  String rg;
  String cpf;
  String senha;
  String telefone;
  LatLng centroide;
  int raio;
  List<LatLng> points;

  //constructor
  Sessao(
      {this.id,
      this.nome,
      this.email,
      this.cep,
      this.rg,
      this.telefone,
      this.cpf,
      this.senha,
      this.centroide,
      this.raio,
      this.points});
  //funcoes
  factory Sessao.fromJson(Map<String, dynamic> json) {
    List<LatLng> parsePoints(Map<String, dynamic> input) {
      List<LatLng> ret = new List<LatLng>();
      int size = json['coordenadasArea'].length;
      double lat, lng;

      for (int i = 0; i < size; i++) {
        lat = json['coordenadasArea'][i]['latitude'] as double;
        lng = json['coordenadasArea'][i]['longitude'] as double;
        ret.add(new LatLng(lat, lng));
      }
      return ret;
    }

    return Sessao(
      id: json['id'] as String,
      nome: json['nome'] as String,
      email: json['email'] as String,
      cep: json['cep'] as String,
      rg: json['rg'] as String,
      cpf: json['cpf'] as String,
      telefone: json['telefone'] as String,
      centroide: new LatLng(json['coordenadaCentroide']['latitude'] as double,
          json['coordenadaCentroide']['longitude'] as double),
      raio: json['raioCentroide'] as int,
      points: parsePoints(json),
    );
  }

  //f(x)
  Sessao copy(Sessao old) {
    Sessao ret = new Sessao();
    ret.id = old.id;
    ret.nome = old.nome;
    ret.email = old.email;
    ret.cep = old.cep;
    ret.rg = old.rg;
    ret.senha = old.senha;
    ret.telefone = old.telefone;
    ret.cpf = old.cpf;
    ret.centroide = old.centroide;
    ret.raio = old.raio;
    ret.points = old.points;
    return ret;
  }

  String getJsonPoints(List<LatLng> p) {
    String ret = "[";
    for (int i = 0; i < p.length; i++) {
      if (i != 0) ret += ",";
      ret += p[i].latitude.toString();
      ret += "," + p[i].longitude.toString();
    }
    ret += "]";
    return ret;
  }

  Future admin_get(String _id) async {
    final http.Response response = await http.get(
        'http://ec2-52-67-230-208.sa-east-1.compute.amazonaws.com:8000/gfas-srv-user/administradores' +
            '/' +
            _id,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });

    if (response.statusCode == 200) {
      print('GET_DB(ID) OK\n');
      Sessao tmp = Sessao.fromJson(jsonDecode(response.body));
      this.id = tmp.id;
      this.nome = tmp.nome;
      this.email = tmp.email;
      //this.senha = tmp.senha;
      this.cep = tmp.cep;
      this.rg = tmp.rg;
      this.telefone = tmp.telefone;
      this.cpf = tmp.cpf;
      this.raio = tmp.raio;
      this.centroide = tmp.centroide;
      this.points = tmp.points;

      return Future.value(true);
    } else {
      print('ERRO' + response.statusCode.toString() + ' :');
      return Future.error("fail");
    }
  }

  Future admin_update(Sessao S) async {
    final http.Response response = await http.put(
      'http://ec2-52-67-230-208.sa-east-1.compute.amazonaws.com:8000/gfas-srv-user/administradores' +
          '/' +
          id,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id': S.id,
        'nome': S.nome,
        'email': S.email,
        'telefone': S.telefone,
        'cpf': S.cpf,
        'rg': S.rg,
        'senha': S.senha,
        'cep': S.cep,
      }),
    );

    if (response.statusCode == 200) {
      print('PUT_ID OK');
      this.id = S.id;
      this.nome = S.nome;
      this.email = S.email;
      this.telefone = S.telefone;
      this.cpf = S.cpf;
      this.rg = S.rg;
      this.cep = S.cep;

      return Future.value(true);
    } else {
      print('ERRO' + response.statusCode.toString() + ' :');
      return Future.error("fail");
    }
  }

  Future login(String tel, String senha) async {
    final http.Response response = await http.post(
      'http://ec2-52-67-230-208.sa-east-1.compute.amazonaws.com:8000/gfas-srv-user/auth',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'login': tel,
        'senha': senha,
      }),
    );

    if (response.statusCode == 200) {
      print('Sucesso no Login');
      Map<String, dynamic> retorno = jsonDecode(response.body);
      return Future.value(retorno['id']);
    } else {
      print('ERRO: ' + response.statusCode.toString());
      return Future.error("fail");
    }
  }
}
