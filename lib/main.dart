import 'package:flutter/material.dart';
import 'package:GFAS/constants.dart';
import 'package:GFAS/login/entrar_opcao.dart';
import 'package:GFAS/login/admin.dart';
import 'package:GFAS/login/bombeiro.dart';
import 'package:GFAS/cadastro/bombeiro.dart';
import 'package:GFAS/cadastro/admin.dart';
import 'package:GFAS/cadastro/opcao.dart';
import 'package:GFAS/users/admin/faq.dart';
import 'package:GFAS/map/cadastra_area.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  runApp(GFASApp());
}

class GFASApp extends StatefulWidget {
  @override
  _GFASAppState createState() => _GFASAppState();
}

class _GFASAppState extends State<GFASApp> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: selectNotification);
  }

  Future selectNotification(String payload) async {
    debugPrint("payload: $payload");
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text('Notification'),
              content: new Text('$payload'),
            ));
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GFAS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
      routes: <String, WidgetBuilder>{
        //login
        '/entrarOpcao': (BuildContext context) => EntrarOpcao(),
        '/loginAdministrador': (BuildContext context) => LoginAdministrador(),
        '/loginBombeiro': (BuildContext context) => LoginBombeiro(),
        //cadastro
        '/cadastroOpcao': (BuildContext context) => CadastroOpcao(),
        '/cadastroAdministrador': (BuildContext context) =>
            CadastroAdministrador(),
        '/cadastraTerreno': (BuildContext context) => CadastraTerreno(),
        '/cadastroBombeiro': (BuildContext context) => CadastroBombeiro(),
        //user
        '/faq': (BuildContext context) => FAQ(),
        //'/mapaAdministrador': (BuildContext context) => MapaAdministrador(),
        //'/menuAdministrador': (BuildContext context) => MenuAdministrador(),
      },
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: <Widget>[
        Center(
          child: Image.asset(
            HOME_LOGO,
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.6,
          ),
        ),
        Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/entrarOpcao');
                },
                child: Container(
                  color: Colors.lightBlue,
                  child: Center(
                    child: Text(
                      ENTRAR,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.07),
                    ),
                  ),
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.01),
                  height: MediaQuery.of(context).size.height * 0.14,
                  width: MediaQuery.of(context).size.width * 0.75,
                )),
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/cadastroOpcao');
                },
                child: Container(
                  color: Colors.red,
                  child: Center(
                    child: Text(
                      CADASTRAR,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.07),
                    ),
                  ),
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.03),
                  height: MediaQuery.of(context).size.height * 0.14,
                  width: MediaQuery.of(context).size.width * 0.75,
                )),
          ],
        )
      ],
    )));
  }
}
