import 'package:GFAS/cadastro_opcao.dart';
import 'package:GFAS/entrar_opcao.dart';
import 'package:GFAS/cadastro_administrador.dart';
import 'package:GFAS/cadastro_bombeiro.dart';
import 'package:GFAS/menu_administrador.dart';
import 'package:GFAS/login_administrador.dart';
import 'package:GFAS/login_bombeiro.dart';
import 'package:GFAS/mapa_administrador.dart';
import 'package:GFAS/faq.dart';
import 'package:GFAS/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

void main() => runApp(GFASApp());

class GFASApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GFASAppExecute();
}

/*lass GFASAppExecute extends State<GFASApp> {
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
      },
    );
    _firebaseMessaging
        .requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.getToken().then((token) {
      print(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],

        // Define the default font family.
        fontFamily: 'Arial',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      title: 'GFAS',
      home: Scaffold(
          body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const SizedBox(
                    height: 5,
                  ),
                  /*if(fogo == 1)
                    showNotification(),*/
                  Center(child: Image.asset(HOME_LOGO, height: 300, width: 250)),
                  HomeButtons(
                    //onPressed: showNotification,
                  )
                ],
              ))),
      routes: <String, WidgetBuilder>{
        '/cadastroAdministrador': (BuildContext context) => CadastroAdministrador(),
        //'/mapaAdministrador': (BuildContext context) => MapaAdministrador(),
        '/menuAdministrador': (BuildContext context) => MenuAdministrador(),
        '/loginAdministrador': (BuildContext context) => LoginAdministrador(),
        '/loginBombeiro': (BuildContext context) => LoginBombeiro(),
        '/cadastroBombeiro': (BuildContext context) => CadastroBombeiro(),
        '/cadastroOpcao': (BuildContext context) => CadastroOpcao(),
        '/entrarOpcao': (BuildContext context) => EntrarOpcao(),
        '/faq': (BuildContext context) => FAQ()
      },
    );
  }

}*/


class GFASAppExecute extends State<GFASApp> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  var fogo = 1;
  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
//    var android = new AndroidInitializationSettings(HOME_LOGO);
    var android = new AndroidInitializationSettings('ic_launcher');
    var ios = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: selectNotification);
  }

  Future selectNotification(String payload) async{
    debugPrint("payload: $payload");
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title: new Text('Notification'),
          content: new Text('$payload'),
        ));
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],

        // Define the default font family.
        fontFamily: 'Arial',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      title: 'GFAS',
      home: Scaffold(
          body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const SizedBox(
                    height: 5,
                  ),
                  /*if(fogo == 1)
                    showNotification(),*/
                  Center(child: Image.asset(HOME_LOGO, height: 300, width: 250)),
                  HomeButtons(
                    onPressed: showNotification,
                  )
                ],
              ))),
      routes: <String, WidgetBuilder>{
        '/cadastroAdministrador': (BuildContext context) => CadastroAdministrador(),
        //'/mapaAdministrador': (BuildContext context) => MapaAdministrador(),
        '/menuAdministrador': (BuildContext context) => MenuAdministrador(),
        '/loginAdministrador': (BuildContext context) => LoginAdministrador(),
        '/loginBombeiro': (BuildContext context) => LoginBombeiro(),
        '/cadastroBombeiro': (BuildContext context) => CadastroBombeiro(),
        '/cadastroOpcao': (BuildContext context) => CadastroOpcao(),
        '/entrarOpcao': (BuildContext context) => EntrarOpcao(),
        '/faq': (BuildContext context) => FAQ()
      },
    );
  }

  Future<void> showNotification() async {
    var android = new AndroidNotificationDetails(
        'channelId', 'channelName', 'channelDescription',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var ios = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, ios);
    await flutterLocalNotificationsPlugin.show(0, 'GFAS', 'Novo Risco', platform,
        payload: 'Esta pegando fogo nesta area');
  }
}

class HomeButtons extends StatelessWidget {
  const HomeButtons({this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        FlatButton(
            /*onPressed: () {
              Navigator.of(context).pushNamed('/entrarOpcao');
            },*/
            onPressed: onPressed,
            child: Container(
              color: Colors.lightBlue,
              child: Center(
                child: Text(ENTRAR, style: TextStyle(fontSize: 28)),
              ),
              width: HOME_LARGURA_BOTAO,
              height: HOME_ALTURA_BOTAO,
            )),
        FlatButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/cadastroOpcao');
            },
            child: Container(
              color: Colors.red,
              child: Center(
                child: Text(CADASTRAR, style: TextStyle(fontSize: 28)),
              ),
              height: HOME_ALTURA_BOTAO,
              margin: EdgeInsets.only(top: 10.0, bottom: 20.0),
              width: HOME_LARGURA_BOTAO,
            )),
      ],
    );
  }
}
