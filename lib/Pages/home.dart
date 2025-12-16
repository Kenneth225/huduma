
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ohresto/Pages/a_propos.dart';
import 'package:ohresto/Pages/cgu.dart';
import 'package:ohresto/Pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:share_plus/share_plus.dart';
import 'menu.dart';
import 'commandes.dart';
import 'profil.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Acceuil extends StatefulWidget {
  Acceuil({Key? key}) : super(key: key);

  @override
  _AcceuilState createState() => _AcceuilState();
}

int currentIndex = 0;
List listofbody = [
  new Menu(),
  new HomePage(),
  new Commandes(),
  new Profil(),
];

class _AcceuilState extends State<Acceuil> {
  @override
  void initState() {
    super.initState();
    connectionCheck();
  }

  bool isLoggedIn = true;
  String name = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0.0,
        title: Text("ohresto"),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(251, 219, 91, 1),
      ),
      body: Center(
        child: listofbody[currentIndex],
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.yellowAccent[700],
              ),
              child: Text('ohresto Menu'),
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.share),
                  SizedBox(
                    width: 2,
                  ),
                  Text('Inviter un ami'),
                ],
              ),
              onTap: () {
                Share.share(
                    "ohresto est l'application la plus cool du BENIN je t'invite à la telecharger également !");
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.card_membership),
                  SizedBox(
                    width: 2,
                  ),
                  Text('CGU'),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Cgu(),
                ));
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.info),
                  SizedBox(
                    width: 2,
                  ),
                  Text('A propos'),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => new Propos(),
                ));
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: currentIndex,
        onItemSelected: (index) {
          setState(
            () {
              currentIndex = index;
            },
          );
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              icon: Icon(Icons.room_service),
              title: Text("Acceuil"),
              activeColor: Color.fromRGBO(251, 219, 91, 1),
              inactiveColor: Colors.blueGrey),
          BottomNavyBarItem(
              icon: Icon(Icons.search),
              title: Text("Recherche"),
              activeColor: Color.fromRGBO(251, 219, 91, 1),
              inactiveColor: Colors.blueGrey),
          BottomNavyBarItem(
              icon: Icon(Icons.restaurant_menu),
              title: Text("Données"),
              activeColor: Color.fromRGBO(251, 219, 91, 1),
              inactiveColor: Colors.blueGrey),
          BottomNavyBarItem(
              icon: Icon(Icons.person),
              title: Text("Profil"),
              activeColor: Color.fromRGBO(251, 219, 91, 1),
              inactiveColor: Colors.blueGrey)
        ],
      ),
    );
  }

  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? usernom = prefs.getString('username');

    if (usernom == null) {
      setState(() {
        isLoggedIn = false;
        name = usernom!;
      });
      Navigator.pushReplacementNamed(context, 'home');
    }
  }

  void connectionCheck() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      // Mobile is not Connected to Internet
      Navigator.pushReplacementNamed(context, 'losted');
    } else if (connectivityResult == ConnectivityResult.mobile) {
      autoLogIn();
    } else if (connectivityResult == ConnectivityResult.wifi) {
      autoLogIn();
    }
  }
}
