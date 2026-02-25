import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ohresto/Pages/Inscription/inscription.dart';
import 'package:ohresto/Pages/home.dart';
import 'package:ohresto/Pages/host.dart';
import 'package:ohresto/Pages/noconnection.dart';
import 'package:http/http.dart' as http;
import 'package:ohresto/bloc/food_bloc.dart';
import 'package:ohresto/bloc/search/search_bloc.dart';
import 'package:ohresto/config.dart';
import 'package:ohresto/controller_api/food_repository.dart';
import 'package:ohresto/controller_api/search_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => FoodBloc(
            repository: FoodRepositoryImpl(),
          ),
        ),
        BlocProvider(
          create: (_) => SearchBloc(
            repository: SearchRepositoryImpl(),
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OHRESTO',
          theme: ThemeData(
            primarySwatch: Colors.green,
            primaryTextTheme:
                TextTheme(displayLarge: TextStyle(color: Colors.white)),
            primaryColor: Colors.white,
            scaffoldBackgroundColor: Color.fromRGBO(245, 245, 245, .9),
          //  buttonColor: Color(0xFF006650)[700],
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: 'invite',
          routes: {
            'home': (context) => Home(),
            'accueil': (context) => new Acceuil(),
            'invite': (context) => new Henu(),
            'losted': (context) => Noconnect()
          },
    );
  }
}

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late TextEditingController emailctrl, passctrl;
  @override
  void initState() {
    super.initState();
    connectionCheck();
    emailctrl = new TextEditingController();
    passctrl = new TextEditingController();
  }

  bool isLoggedIn = false;
  String name = '';
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
              height: 830,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 400,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('images/themo.png'),
                                fit: BoxFit.fill)),
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              left: 30,
                              width: 80,
                              height: 200,
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('images/light-1.png'))),
                              ),
                            ),
                            Positioned(
                              left: 140,
                              width: 80,
                              height: 150,
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('images/light-2.png'))),
                              ),
                            ),
                            Positioned(
                              right: 40,
                              top: 40,
                              width: 80,
                              height: 150,
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('images/clock.png'))),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(30.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Container(
                                
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color.fromRGBO(143, 148, 251, .2),
                                          blurRadius: 20.0,
                                          offset: Offset(0, 10))
                                    ]),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey))),
                                      child: TextField(
                                        controller: emailctrl,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Email",
                                            hintStyle:
                                                TextStyle(color: Colors.grey[400])),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextField(
                                        obscureText: _isObscure,
                                        controller: passctrl,
                                        decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                                icon: Icon(_isObscure
                                                    ? Icons.visibility
                                                    : Icons.visibility_off),
                                                onPressed: () {
                                                  setState(() {
                                                    _isObscure = !_isObscure;
                                                  });
                                                }),
                                            border: InputBorder.none,
                                            hintText: "Mot de Passe",
                                            hintStyle:
                                                TextStyle(color: Colors.grey[400])),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(colors: [
                                      Color.fromRGBO(0, 0, 0, 1),
                                      Color(0xFF006650),
                                    ])),
                                child: Center(
                                  child: TextButton(
                                    onPressed: () {
                                      login();
                                    },
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              TextButton(
                                  onPressed: () {
                                    pageinscription();
                                  },
                                  child: Text("Inscription",
                                      style: TextStyle(
                                          color: Color(0xFF006650)))),
                              TextButton(
                                  onPressed: () {
                                    mdpO();
                                  },
                                  child: Text(
                                    "Mot de passe oublié?",
                                    style: TextStyle(
                                        color: Color(0xFF006650)),
                                  )),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
            ],
          ),
          ),
        );
  }

  void mdpO() async {
    if (emailctrl.text == "") {
      Fluttertoast.showToast(
          msg: "Veillez entrez un mail", toastLength: Toast.LENGTH_SHORT);
    } else if (EmailValidator.validate(emailctrl.text) == false) {
      Fluttertoast.showToast(
          msg: "Veillez entrez un mail valide",
          toastLength: Toast.LENGTH_SHORT);
    } else {
      var url = Uri.parse("${api_link}/myinfos.php");
      var data = {
        "email": emailctrl.text,
        "password": passctrl.text,
      };

      var res = await http.post(url, body: data);
      if (res.statusCode == 200) {
        if (jsonDecode(res.body) == "true") {
          Fluttertoast.showToast(
              msg: "Votre mot de passe vous a été envoyé par mail",
              toastLength: Toast.LENGTH_SHORT);
        } else {
          Fluttertoast.showToast(
              msg:
                  "Votre mail n'est associer à aucun compte, veillez en creer un",
              toastLength: Toast.LENGTH_SHORT);
        }
      }
    }
  }

  void login() async {
    CircularProgressIndicator();
    var url = Uri.parse("${api_link}/test.php");
    var data = {
      "email": emailctrl.text,
      "password": passctrl.text,
    };

    var res = await http.post(url, body: data);
    if (res.statusCode == 200) {
      if (jsonDecode(res.body) == "pas de compte") {
        Fluttertoast.showToast(
            msg: "Email ou Mot de passe erroné",
            toastLength: Toast.LENGTH_SHORT);
        print("Echec");
      } else if (jsonDecode(res.body) == "pas valide") {
        Fluttertoast.showToast(
            msg: "Veillez confirmez votre compte depuis votre compte mail",
            toastLength: Toast.LENGTH_LONG);
      }

      var jsonData = jsonDecode(res.body);
      print(jsonData);

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('id', jsonData[0]["id"]);
      prefs.setString('email', jsonData[0]["email"]);
      prefs.setString('username', jsonData[0]["username"]);
      prefs.setString('telephone', jsonData[0]["telephone"]);
      prefs.setString('status', jsonData[0]["status"]);

      setState(() {
        name = jsonData[0]["username"];
        isLoggedIn = true;
        print(name);
      });
      print(jsonData);
      Navigator.pushReplacementNamed(context, 'accueil');
      Fluttertoast.showToast(
          msg: "Connection effectué", toastLength: Toast.LENGTH_SHORT);
      print("Done");
    } else {
      Fluttertoast.showToast(msg: "Echec", toastLength: Toast.LENGTH_SHORT);
      print("Echec");
    }
  }

  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? usernom = prefs.getString('username');

    if (usernom != null) {
      setState(() {
        isLoggedIn = true;
        name = usernom;
      });
      Navigator.pushReplacementNamed(context, 'accueil');
    }
  }

  void connectionCheck() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // Mobile is not Connected to Internet
      Navigator.pushReplacementNamed(context, 'losted');
      print('no connection');
    } else if (connectivityResult == ConnectivityResult.mobile) {
      print('mobile connection');
      autoLogIn();
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print('wifi connection');
      autoLogIn();
    }
  }

  void pageinscription() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => new Inscription()));
  }
}

class Users {
  String? id;
  String? email;
  String? username;
  String? telephone;
  String? naissance;
  String? password;
  String? status;

  Users(
      {this.id,
      this.email,
      this.username,
      this.telephone,
      this.naissance,
      this.password,
      this.status});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    username = json['username'];
    telephone = json['telephone'];
    naissance = json['naissance'];
    password = json['password'];
    status = json['status'];
  }
}
