
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ohresto/Pages/a_propos.dart';
import 'package:ohresto/Pages/cgu.dart';
import 'package:ohresto/Structures/menu_structure.dart';
import 'package:ohresto/Structures/resto_structure.dart';
import 'package:ohresto/controller_api/menu_api.dart';
import 'package:ohresto/controller_api/resto_api.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';




class Henu extends StatefulWidget {
  const Henu({Key? key}) : super(key: key);

  @override
  _HenuState createState() => _HenuState();
}

class _HenuState extends State<Henu> with SingleTickerProviderStateMixin {
  late Future<List<Menus>> menuFuture;
  late Future<List<Restaurants>> restoFuture;
  late TabController _tabController;

  String localLongitude = "";
  String localLatitude = "";
  double? _milles;

  bool isLoggedIn = false;
  String name = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    connectionCheck();

    menuFuture = menu();
    restoFuture = resto();

    getCurrentLocation();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Retourne la liste des menus
  Future<List<Menus>> menu() async {
    final result = await fetchmenus();
    return result.cast<Menus>();
  }

  /// Retourne la liste des restaurants
  Future<List<Restaurants>> resto() async {
    final result = await fetchrestos();
    return result.cast<Restaurants>();
  }

  /// Vérifie la connexion Internet
  void connectionCheck() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      Navigator.pushReplacementNamed(context, 'losted');
    } else {
      autoLogIn();
    }
  }

  /// Auto login si SharedPreferences contient un utilisateur
  void autoLogIn() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userNom = prefs.getString('username');

    if (userNom != null) {
      setState(() {
        isLoggedIn = true;
        name = userNom;
      });
      Navigator.pushReplacementNamed(context, 'accueil');
    }
  }

  /// Récupère la position actuelle
  Future<void> getCurrentLocation() async {
    final geoposition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      localLatitude = geoposition.latitude.toString();
      localLongitude = geoposition.longitude.toString();
    });
  }

  /// Calcule la distance entre le restaurant et l'utilisateur
  Future<double> getRestLocation(double lat, double long) async {
    final geoposition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final distance = Distance();
    double rkm = distance.as(
      LengthUnit.Kilometer,
      LatLng(geoposition.latitude, geoposition.longitude),
      LatLng(lat, long),
    );
    return rkm;
  }

  /// Affiche un modal demandant la création de compte
  Future<void> showMymodal(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text("ATTENTION !"),
        content: const Text(
            "Pour effectuer cette action vous devez avoir un compte",
            style: TextStyle(fontSize: 18)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, 'home'),
            child: const Text('Ouvrir mon compte'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(251, 219, 91, 1),
        title: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            height: 100,
            color: const Color.fromRGBO(251, 219, 91, 1),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              tabs: const [
                Tab(text: "Livraison"),
                Tab(text: "Restaurants"),
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.yellowAccent),
              child: Text('ohresto Menu'),
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Inviter un ami'),
              onTap: () {
                Share.share(
                    "ohresto est l'application la plus cool du BENIN je t'invite à la telecharger également !");
              },
            ),
            ListTile(
              leading: const Icon(Icons.card_membership),
              title: const Text('CGU'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => Cgu()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('A propos'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Propos()),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          /// Onglet Livraison
          Column(
            children: [
              const SizedBox(height: 16),
              const Text(
                "Les menus du jour",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Menus>>(
                  future: menuFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: Colors.yellow,
                      ));
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Erreur: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("Aucun menu disponible"));
                    }

                    final menus = snapshot.data!;
                    return ListView.builder(
                      itemCount: menus.length,
                      itemBuilder: (context, index) {
                        final menu = menus[index];
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                menu.restaurantName?? "",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              Text(
                                'Benin | ${menu.restaurantAddress}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 10),
                              TextButton(
                                onPressed: () => showMymodal(context),
                                child: const Text("Voir",
                                    style: TextStyle(
                                        color:
                                            Color.fromRGBO(251, 219, 91, 1))),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),

          /// Onglet Restaurants
          FutureBuilder<List<Restaurants>>(
            future: restoFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Erreur: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("Aucun restaurant disponible"));
              }

              final restos = snapshot.data!;
              return ListView.builder(
                itemCount: restos.length,
                itemBuilder: (context, index) {
                  final resto = restos[index];
                  return ListTile(
                    title: Text(
                      resto.restaurantName?? "",
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Benin | ${resto.restaurantAddress}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () => showMymodal(context),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
