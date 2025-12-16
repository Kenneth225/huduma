import 'package:ohresto/main.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class Inscription extends StatefulWidget {
  Inscription({ Key? key}) : super(key: key);

  @override
  _InscriptionState createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  bool processing = false;
  late TextEditingController emailctrl, usernamectrl, telctrl, passctrl, passtoctrl;
  @override
  void initState() {
    super.initState();
    emailctrl = new TextEditingController();
    usernamectrl = new TextEditingController();
    telctrl = new TextEditingController();
    passctrl = new TextEditingController();
    passtoctrl = new TextEditingController();
  }


  bool _isObscure = true;
  bool _isObscured = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
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
                      Positioned(
                        child: Container(
                          margin: EdgeInsets.only(top: 50),
                          child: Center(
                            child: Text(
                              "",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
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
                                      bottom:
                                          BorderSide(color: Colors.grey))),
                              child: TextField(
                                controller: usernamectrl,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Nom d'utilisateur",
                                    hintStyle:
                                        TextStyle(color: Colors.grey)),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey))),
                              child: TextField(
                                keyboardType: TextInputType.emailAddress,
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
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey))),
                              child: TextField(
                                maxLengthEnforcement: MaxLengthEnforcement.none, keyboardType: TextInputType.phone,
                                maxLength: 8,
                                controller: telctrl,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Telephone",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: TextField(
                                 obscureText: _isObscure,
                                keyboardType: TextInputType.visiblePassword,
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
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: TextField(
                                 obscureText: _isObscured,
                                keyboardType: TextInputType.visiblePassword,
                                controller: passtoctrl,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                                icon: Icon(_isObscured
                                                    ? Icons.visibility
                                                    : Icons.visibility_off),
                                                onPressed: () {
                                                  setState(() {
                                                    _isObscured = !_isObscured;
                                                  });
                                                }),
                                    border: InputBorder.none,
                                    hintText: "Confirmation Mot de Passe",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                              ),
                            ),
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
                              Color.fromRGBO(251, 219, 91, 1),
                            ])),
                        child: Center(
                          child: TextButton(
                            onPressed: () {
                              signup();
                            },
                            child: processing == false
                                ? Text(
                                    "Inscription",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                : CircularProgressIndicator(
                                    backgroundColor: Colors.red),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("J'ai un compte",
                              style: TextStyle(
                                  color: Color.fromRGBO(251, 219, 91, 1)))),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void pagelog() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => new Home()));
  }

  void signup() async {
    if (passctrl.text == "") {
     
      Fluttertoast.showToast(
          msg: "Veillez entrez un mot de passe",
          toastLength: Toast.LENGTH_SHORT);
    } else if (emailctrl.text == "") {
      Fluttertoast.showToast(
          msg: "Veillez entrez un mail",
          toastLength: Toast.LENGTH_SHORT);
    }else if(usernamectrl.text == "") {
      Fluttertoast.showToast(
          msg: "Veillez entrez un nom d'utilisateur",
          toastLength: Toast.LENGTH_SHORT);
    }else if (telctrl.text == "") {
      Fluttertoast.showToast(
          msg: "Veillez entrez un numero de telephone",
          toastLength: Toast.LENGTH_SHORT);
    }else if( passctrl.text.length <= 5) {
      Fluttertoast.showToast(
          msg: "Veillez entrez un mot de passe d'au moins 6 caractères",
          toastLength: Toast.LENGTH_SHORT);
    }else if( telctrl.text.length > 8) {
      Fluttertoast.showToast(
          msg: "Veillez entrez un numero de 8 chiffres",
          toastLength: Toast.LENGTH_SHORT);
    }else if (passtoctrl.text == "") {
      Fluttertoast.showToast(
          msg: "Veillez confirmer votre mot de passe",
          toastLength: Toast.LENGTH_SHORT);
    }
    else if (EmailValidator.validate(emailctrl.text) == false) {
      Fluttertoast.showToast(
          msg: "Veillez entrez un mail valide",
          toastLength: Toast.LENGTH_SHORT);
    }else{
      chargement();
    }
    
  }

  Future<void> showMymodal(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("ATTENTION !"),
          content: SingleChildScrollView(
              child: Center(
                  child: Column(children: <Widget>[
            Text(
              "Continuez la création de votre compte en procédant à la confirmation de votre adresse email",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              "Verifiez votre boite de réception ou dans vos spams",
              style: TextStyle(fontSize: 14),
            ),
          ]))),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                pagelog();
              },
            ),
            
          ],
        );
      },
    );
  }



  void chargement() async{
    

    setState(() {
      processing = true;
    });

    if (passtoctrl.text != passctrl.text) {
      Fluttertoast.showToast(
          msg: "Mot de passe de confirmation incompatible",
          toastLength: Toast.LENGTH_SHORT);
    } else {
      var url = Uri.parse("http://demoalito.mydevcloud.com/api/inscorp.php");
      var data = {
        "email": emailctrl.text,
        "username": usernamectrl.text,
        "telephone": telctrl.text,
        "password": passctrl.text,
      };

      var res = await http.post(url, body: data);
      if (jsonDecode(res.body) == "exist") {
        Fluttertoast.showToast(
            msg: "Email /ou Nom d'utilisateur  deja utilisé", toastLength: Toast.LENGTH_SHORT);
            setState(() {
      processing = false;
    });
      } else {
        if (jsonDecode(res.body) == "true") {
          Fluttertoast.showToast(
              msg: "Compte crée", toastLength: Toast.LENGTH_SHORT);
          setState(() {
      processing = true;
    });
    showMymodal(context);
        } else {
          Fluttertoast.showToast(
              msg: "Erreur", toastLength: Toast.LENGTH_SHORT);
        }
      }
    }
  }
}
