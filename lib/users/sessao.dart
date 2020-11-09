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
  String senha;
  String rg;
  String cpf;
  String telefone;
  String raio;
  //pos-vars
  LatLng centroide;
  var points = <LatLng>[];
  //constructor
  Sessao(
      {this.id,
      this.nome,
      this.email,
      this.senha,
      this.cep,
      this.rg,
      this.telefone,
      this.cpf,
      this.raio,
      this.centroide,
      this.points});
  //funcoes
  factory Sessao.fromJson(Map<String, dynamic> json) {
    //double lat = json['lat_centro'] as double;
    //double lng = json['lng_centro'] as double;
    //var pts = jsonDecode(json['points']).cast<LatLng>();
    return Sessao(
      id: json['id'] as String,
      nome: json['nome'] as String,
      email: json['email'] as String,
      cep: json['cep'] as String,
      rg: json['rg'] as String,
      cpf: json['cpf'] as String,
      telefone: json['telefone'] as String,
      //centroide: new LatLng(lat, lng),
      //senha: json['senha'] as String,
      raio: json['raio'] as String,
      //points: pts,
      //todo: ver se funcionou o parse dos points, precisa adicionar campos de cadastro.
    );
  }

  //f(x)
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
      print('GET_ID OK\n' + response.body);
      Sessao tmp = Sessao.fromJson(jsonDecode(response.body));
      this.id = tmp.id;
      this.nome = tmp.nome;
      this.email = tmp.email;
      //this.senha = tmp.senha;
      this.cep = tmp.cep;
      this.rg = tmp.rg;
      this.telefone = tmp.telefone;
      this.cpf = tmp.cpf;
      print("id: " +
          this.id +
          "\n" +
          "nome: " +
          this.nome +
          //"\n senha:" +
          //this.senha +
          "\n" +
          "email: " +
          this.email +
          "\n" +
          "cep: " +
          this.cep +
          "\n" +
          "rg: " +
          this.rg +
          "\n" +
          "cpf: " +
          this.cpf +
          "\n" +
          "telefone: " +
          this.telefone +
          "\n");
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
        'senha':
            S.senha, //preciso atualizar a senha pra continuar tendo senha...
        'email': S.email,
        'telefone': S.telefone,
        'cpf': S.cpf,
        'rg': S.rg,
        'cep': S.cep,
        //'lat_centro': centroide.latitude.toString(),
        //'lng_centro': centroide.longitude.toString(),
        //'raio': raio.toString(),
        //'points': getJsonPoints(points),
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
}
