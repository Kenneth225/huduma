import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Noconnect extends StatefulWidget {
  const Noconnect({Key? key}) : super(key: key);

  @override
  _NoconnectState createState() => _NoconnectState();
}

class _NoconnectState extends State<Noconnect> {
    bool isLoggedIn = false;
  String name = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Column(
                              children: [
                                SizedBox(height: MediaQuery.of(context).size.height / 3,),
                                Icon(Icons.wifi_lock, size: 100.2,color: Colors.white,),
                                Center(
                            child: Text(
                              "Veillez vous connecter",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          TextButton(onPressed:(){ 
                            connectionCheck(context);}, child: Text("Verifier ma connexion"))

                              ],
                             ),
    );
  }

void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
     String? usernom = prefs.getString('username');

    if (usernom != null) {
      setState(() {
        isLoggedIn = true;
        name = usernom;
      });
      Navigator.pushReplacementNamed(context, 'accueil');
    }
  }

  void connectionCheck(context) async{
    final connectivityResult = await Connectivity().checkConnectivity();
if (connectivityResult == ConnectivityResult.none) {
  // Mobile is not Connected to Internet
  Navigator.pushReplacementNamed(context, 'losted');
  print('no connection');
}
else if (connectivityResult == ConnectivityResult.mobile) {
  print('mobile connection');
  autoLogIn();
}

 else if (connectivityResult == ConnectivityResult.wifi) {
   print('wifi connection');
 autoLogIn();
}
  }
}
