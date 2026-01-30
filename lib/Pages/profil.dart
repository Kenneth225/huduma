
import 'package:ohresto/Pages/list_recettes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class Profil extends StatefulWidget {
  Profil({Key? key}) : super(key: key);

  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  String? username;
  String? tel;
  String? mail;
  String? nbetoile;
  @override
  void initState() {
    super.initState();
    test();
  }

  void test() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("username"));

    setState(() {
      username = prefs.getString("username");
      tel = prefs.getString("telephone");
      mail = prefs.getString("email");
      nbetoile = prefs.getString("etoile");
    });
  }

  Widget _changed() {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage('images/user.png'),
              ),
              Text(
                '${username}',
                style: TextStyle(
                  fontSize: 30.0,
                  fontFamily: 'Pacifico',
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 20.0,
                width: 150,
                child: Divider(
                  color: Colors.teal.shade100,
                ),
              ),
              InkWell(
                  child: Card(
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.phone,
                        color: Color(0xFF006650),
                      ),
                      title: Text(
                        '${tel}',
                        style: TextStyle(
                            fontFamily: 'SourceSansPro',
                            fontSize: 20,
                            color: Colors.teal.shade900),
                      ),
                    ),
                  ),
                  onTap: () {}),
              InkWell(
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.email,
                      color: Color(0xFF006650),
                    ),
                    title: Text(
                      '${mail}',
                      style: TextStyle(
                          fontFamily: 'SourceSansPro',
                          fontSize: 20,
                          color: Colors.teal.shade900),
                    ),
                  ),
                ),
                onTap: () {},
              ),
              InkWell(
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.food_bank,
                      color: Color(0xFF006650),
                    ),
                    title: Text(
                      'Recettes',
                      style: TextStyle(
                          fontFamily: 'SourceSansPro',
                          fontSize: 20,
                          color: Colors.teal.shade900),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => new RecettesList(),
                  ));
                },
              ),
              InkWell(
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.star,
                      color: Color(0xFF006650),
                    ),
                    title: Text(
                      '${nbetoile} HUMS',
                      style: TextStyle(
                          fontFamily: 'SourceSansPro',
                          fontSize: 20,
                          color: Colors.teal.shade900),
                    ),
                  ),
                ),
                onTap: () {},
              ),
              InkWell(
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Color(0xFF006650),
                    ),
                    title: Text(
                      'Deconnexion',
                      style: TextStyle(
                          fontFamily: 'SourceSansPro',
                          fontSize: 20,
                          color: Colors.teal.shade900),
                    ),
                  ),
                ),
                onTap: () {
                  logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    Navigator.pushReplacementNamed(context, 'home');
    Fluttertoast.showToast(msg: "Deconnexion", toastLength: Toast.LENGTH_SHORT);
    print("Done");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Container(child: Column(children: [SizedBox(height: 35), _changed()])));
  }
}
